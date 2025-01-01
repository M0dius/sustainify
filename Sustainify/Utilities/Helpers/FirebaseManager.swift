//
//  FirebaseManager.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit
import Firebase
import Foundation
import FirebaseFirestore

class FirebaseManager {
    private static let db = Firestore.firestore()
    
    static func fetchStore(with storeId: String, completion: @escaping (RetailStore?) -> Void) {
        db.collection("Stores").document(storeId).getDocument { document, error in
            guard let data = document?.data() else {
                completion(nil)
                return
            }
            completion(RetailStore.fromDictionary(data))
        }
    }
    
    static func fetchProducts(for storeId: String, completion: @escaping ([Product]) -> Void) {
        db.collection("Stores").document(storeId).collection("Products").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            let products = documents.compactMap { doc in
                Product.fromDictionary(doc.data())
            }
            
            completion(products)
        }
    }
    
    static func saveStore(_ store: RetailStore) {
        let storeData = store.mapToDictionary()
        db.collection("Stores").document(store.id).setData(storeData)
    }
    
    static func saveProduct(_ product: Product, to storeId: String) {
        let productData = product.mapToDictionary()
        db.collection("Stores").document(storeId).collection("Products").document(product.id).setData(productData)
    }
    
    static func saveMockData() {
        let mockStores = RetailStore.generateMockStores()
        
        mockStores.forEach { store in
            saveStore(store)
            let mockProducts = Product.generateMockProducts(storeId: store.id)
            mockProducts.forEach { product in
                saveProduct(product, to: store.id)
            }
        }
    }
    
    static func bookProduct(_ product: Product, completion: @escaping (Error?) -> Void) {
        var bookingData = product.mapToDictionary()
        bookingData["timestamp"] = FieldValue.serverTimestamp()
        db.collection("Bookings").addDocument(data: bookingData) { error in
            completion(error)
        }
    }
    
    static func fetchVouchers(completion: @escaping ([Voucher]) -> Void) {
        db.collection("Vouchers").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            let vouchers = documents.compactMap { doc in
                Voucher.fromDictionary(doc.data())
            }
            
            completion(vouchers)
        }
    }
    
    /// Saves a dictionary of products with their counts to the `Cart` collection in Firebase.
    /// - Parameters:
    ///   - productsToCheckout: A dictionary of `Product` and their respective counts.
    static func saveProductsToCart(_ productsToCheckout: [Product: Int], completion: @escaping (Error?) -> Void) {
        let batch = db.batch()
        let cartRef = db.collection("Cart")
        
        productsToCheckout.forEach { (product, count) in
            let productRef = cartRef.document(product.id)
            var productData = product.mapToDictionary()
            productData["count"] = count
            batch.setData(productData, forDocument: productRef)
        }
        
        batch.commit { error in
            completion(error)
        }
    }
    
    /// Updates the count of a specific product in the `Cart` collection.
    /// - Parameters:
    ///   - product: The `Product` to update.
    ///   - count: The new count for the product.
    static func updateCartProductCount(_ product: Product, count: Int, completion: @escaping (Error?) -> Void) {
        let productRef = db.collection("Cart").document(product.id)
        
        productRef.updateData(["count": count]) { error in
            completion(error)
        }
    }
}
