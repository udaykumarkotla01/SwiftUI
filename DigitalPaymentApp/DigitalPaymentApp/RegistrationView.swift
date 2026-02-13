//
//  RegistrationView.swift
//  DigitalPaymentApp
//
//  Created by Uday Kumar Kotla on 13/02/26.
//

import SwiftUI

struct RegistrationView: View {
    @State private var phoneNumber: String = ""
    @State private var name: String = ""
    @State private var iban: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "j.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                    
                    Text("Join PayNexus")
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.top, 50)
                
                // Form Fields
                VStack(alignment: .leading, spacing: 15) {
                    CustomTextField(label: "Enter Name", placeholder: "Name", text: $name, icon: "person")
                        .keyboardType(.phonePad)
                    CustomTextField(label: "Phone Number", placeholder: "Enter Phone NUMBER", text: $phoneNumber, icon: "phone")
                        .keyboardType(.phonePad)
                    
                    CustomTextField(label: "IBAN", placeholder: "DE00 0000 0000...", text: $iban, icon: "building.columns")
                        .textInputAutocapitalization(.characters)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Submit Button
                Button(action: {
                    // Simple validation check
                    if !phoneNumber.isEmpty && !iban.isEmpty {
                        isLoggedIn = true
                    }
                }) {
                    Text("Submit & Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(phoneNumber.isEmpty || iban.isEmpty ? Color.gray : Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                .disabled(phoneNumber.isEmpty || iban.isEmpty)
            }
            // Navigation destination
            .navigationDestination(isPresented: $isLoggedIn) {
                DigitalPayments()
                    .navigationBarBackButtonHidden(true) // Prevent going back to login
            }
        }
    }
}

// Reusable Styled Text Field
struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .bold()
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                TextField(placeholder, text: $text)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
}

#Preview {
    RegistrationView()
}
