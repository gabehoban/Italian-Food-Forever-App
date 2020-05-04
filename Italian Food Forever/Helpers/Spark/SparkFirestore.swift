//
//  SparkFirestore.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import FirebaseFirestore

struct SparkFirestore {
	static func retreiveProfile(uid: String, completion: @escaping (Result<Profile, Error>) -> Void) {
		let reference = Firestore
			.firestore()
			.collection(SparkKeys.CollectionPath.profiles)
			.document(uid)
		getDocument(for: reference) { result in
			switch result {
			case .success(let data):
				guard let profile = Profile(documentData: data) else {
					completion(.failure(SparkAuthError.noProfile))
					return
				}
				completion(.success(profile))
			case .failure(let err):
				completion(.failure(err))
			}
		}

	}

	static func mergeProfile(_ data: [String: Any], uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
		let reference = Firestore
			.firestore()
			.collection(SparkKeys.CollectionPath.profiles)
			.document(uid)
		reference.setData(data, merge: true) { err in
			if let err = err {
				completion(.failure(err))
				return
			}
			completion(.success(true))
		}
	}

	static func updateData(id: String, txt: [String], completion: @escaping (Result<Bool, Error>) -> Void) {
		Firestore.firestore().collection("profiles").document(id).updateData(["saved": txt]) { err in
			if err != nil {
				utils().LOG(error: err!.localizedDescription, value: "", title: "func updateData")
				return
			}
		}
	}

	// MARK: - fileprivate

	fileprivate static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String: Any], Error>) -> Void) {
		reference.getDocument { documentSnapshot, err in
			if let err = err {
				completion(.failure(err))
				return
			}
			guard let documentSnapshot = documentSnapshot else {
				completion(.failure(SparkAuthError.noDocumentSnapshot))
				return
			}
			guard let data = documentSnapshot.data() else {
				completion(.failure(SparkAuthError.noSnapshotData))
				return
			}
			completion(.success(data))
		}
	}
}
