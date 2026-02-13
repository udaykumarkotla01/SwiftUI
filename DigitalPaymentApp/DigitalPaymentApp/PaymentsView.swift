//
//  PaymentsView.swift
//  DigitalPaymentApp
//
//  Created by Uday Kumar Kotla on 13/02/26.
//

import SwiftUI

import SwiftUI

struct PaymentView: View {
    @State private var amount: String = ""
    @State private var paymentProcessing = false
    @State private var paymentDone = false
    
    // Mock Data
    let recipientName = "MY User"
    let upiId = "9#######@ybl"
    
    var body: some View {
        VStack(spacing: 30) {
            // MARK: - Top Header (User Info)
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Text("YU") // Initials for  User"
                        .font(.title.bold())
                        .foregroundColor(.orange)
                }
                
                VStack(spacing: 4) {
                    Text("Paying \(recipientName)")
                        .font(.headline)
                    
                    Text(upiId)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 40)

            // MARK: - Amount Input
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text("₹")
                        .font(.system(size: 40, weight: .bold))
                    
                    TextField("0", text: $amount)
                        .font(.system(size: 60, weight: .bold))
                        .keyboardType(.decimalPad)
                        .fixedSize() // Keeps the field tight around the text
                }
                
                Text("Add a message (optional)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 40)

            Spacer()
            
            // MARK: - Secure Pay Button
            if paymentDone {
                SuccessView()
            } else {
                Button(action: startPayment) {
                    HStack {
                        if paymentProcessing {
                            ProgressView()
                                .tint(.white)
                                .padding(.trailing, 10)
                        } else {
                            Image(systemName: "lock.fill")
                        }
                        
                        Text(paymentProcessing ? "Processing..." : "Pay Securely ₹\(amount.isEmpty ? "0" : amount)")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(amount.isEmpty ? Color.gray : Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .disabled(amount.isEmpty || paymentProcessing)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .padding()
    }

    // Payment Logic
    func startPayment() {
        paymentProcessing = true
        
        // Simulate a network delay for the "Secure" feel
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            paymentProcessing = false
            withAnimation(.spring()) {
                paymentDone = true
            }
        }
    }
}

// MARK: - Success Component
struct SuccessView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            
            Text("Payment Successful!")
                .font(.headline)
        }
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    PaymentView()
}
