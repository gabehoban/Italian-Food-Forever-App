//
//  SignInView.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Sign In to Save Recipies")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 250.0)
                    .padding(.leading, 10)
                    .frame(width: 250.0)
                    .shadow(color: .black, radius: 6, x: 4, y: 4)
                Spacer()
            }
            //Spacer()
            ActivityIndicatorView(isPresented: $activityIndicatorInfo.isPresented, message: activityIndicatorInfo.message) {
                VStack {
                    Spacer()
                    SignInWithAppleView(activityIndicatorInfo: self.$activityIndicatorInfo, alertInfo: self.$alertInfo)
                        .frame(width:350, height: 50)
                        .padding(.bottom, 50.0)

                }
            }
        }.background(
            Image("pasta")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }
    
    // MARK: - Activity Indicator
    @State private var activityIndicatorInfo = SparkUIDefault.activityIndicatorInfo

    func startActivityIndicator(message: String) {
        activityIndicatorInfo.message = message
        activityIndicatorInfo.isPresented = true
    }

    func stopActivityIndicator() {
        activityIndicatorInfo.isPresented = false
    }

    func updateActivityIndicator(message: String) {
        stopActivityIndicator()
        startActivityIndicator(message: message)
    }
    
    // MARK: - Alert
    @State private var alertInfo = SparkUIDefault.alertInfo
    
    func presentAlert(title: String, message: String, actionText: String = "Ok", actionTag: Int = 0) {
        alertInfo.title = title
        alertInfo.message = message
        alertInfo.actionText = actionText
        alertInfo.actionTag = actionTag
        alertInfo.isPresented = true
    }
    
    func executeAlertAction() {
        switch alertInfo.actionTag {
        case 0:
            print("No action alert action")
            
        default:
            print("Default alert action")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
