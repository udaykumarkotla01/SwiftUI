//
//  TransactionHistoryView.swift
//  DigitalPaymentApp
//
//  Created by Uday Kumar Kotla on 13/02/26.
//


import SwiftUI

struct TransactionHistoryView: View {
    @State private var selectedYear = "2026"
    let years = ["2026", "2025", "2024", "2023"]
    
    // Mock Data for 5 transactions
    let transactions = [
        Transaction(name: "Starbucks Coffee", date: "Today, 10:15 AM", amount: "- ₹350", isCredit: false),
        Transaction(name: "Salary Credit", date: "Feb 1, 2026", amount: "+ ₹75,000", isCredit: true),
        Transaction(name: "Amazon India", date: "Jan 28, 2026", amount: "- ₹1,200", isCredit: false),
        Transaction(name: "Zomato Order", date: "Jan 25, 2026", amount: "- ₹450", isCredit: false),
        Transaction(name: "Refund: Apple", date: "Jan 20, 2026", amount: "+ ₹2,500", isCredit: true)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Year Selector
            HStack {
                Text("Transactions")
                    .font(.title2.bold())
                
                Spacer()
                
                Menu {
                    ForEach(years, id: \.self) { year in
                        Button(year) {
                            selectedYear = year
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedYear)
                        Image(systemName: "chevron.down")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().stroke(Color.gray.opacity(0.3)))
                }
            }
            .padding()
            .background(Color.white)

            // MARK: - Transaction List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(transactions) { item in
                        TransactionRow(transaction: item)
                        Divider().padding(.leading, 70)
                    }
                }
                .background(Color.white)
            }
            
            Spacer()
        }
        .background(Color.gray.opacity(0.05))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Supporting Views & Models

struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let date: String
    let amount: String
    let isCredit: Bool
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(transaction.isCredit ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 45, height: 45)
                
                Image(systemName: transaction.isCredit ? "arrow.down.left" : "arrow.up.right")
                    .foregroundColor(transaction.isCredit ? .green : .black)
                    .font(.system(size: 14, weight: .bold))
            }
            
            // Name and Date
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.name)
                    .font(.system(size: 16, weight: .semibold))
                Text(transaction.date)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Amount
            Text(transaction.amount)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(transaction.isCredit ? .green : .black)
        }
        .padding()
    }
}

#Preview {
    TransactionHistoryView()
}
