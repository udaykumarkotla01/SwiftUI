//
//  ContentView.swift
//  DigitalPaymentApp
//
//  Created by Uday Kumar Kotla on 13/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            RegistrationView()
            
        }
        .padding()
    }
}


struct DigitalPayments: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HeaderView()
                    
                    CardSection()
                    // Quick Action Grid
                    ActionGrid()
                    
                    // UPI ID Bar
                    UpiIdBar()
                    
                    // Welcome Quest Card
                    TaskCard()
                    
                }
                .padding(.bottom, 100) // Space for Tab Bar
            }
            .background(Color(white: 0.98))
            
            // Custom Tab Bar
            CustomTabBar()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Subviews

struct HeaderView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.black)
                .frame(width: 40, height: 40)
                .overlay(Text("UK").foregroundColor(.white).bold())
            
            Spacer()
            
            HStack(spacing: 15) {
                HStack(spacing: 4) {
                    Image(systemName: "hexagon.fill")
                        .foregroundColor(.orange)
                    Text("Rewards")
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().stroke(Color.gray.opacity(0.3)))
                
                Image(systemName: "bell")
                Image(systemName: "magnifyingglass")
            }
        }
        .padding(.horizontal)
    }
}

struct TaskCard: View {
    var body: some View {
        VStack(spacing: 0) {
            // Top Teal Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Get Rewarded")
                    .font(.subheadline)
                
                ProgressView(value: 0.1)
                    .tint(Color(red: 0.2, green: 0, blue: 0.4))
                
                Text("EARN COINS")
                    .font(.caption2).bold()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(LinearGradient(colors: [Color.blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            
            // Tasks
            VStack(spacing: 15) {
                TaskRow(icon: "qrcode", title: "Make 5 UPI Payments", reward: "100")
                Divider()
                TaskRow(icon: "creditcard", title: "Track your credit card", reward: "100")
                Divider()
                TaskRow(icon: "doc.text", title: "Pay credit card bill", reward: "150")
            }
            .padding()
            .background(Color.white)
            
            // Footer
            HStack {
                Text("Use Coins for gift cards")
                    .font(.caption)
                Spacer()
                Text("5 coins = ₹1").font(.caption).bold()
            }
            .padding(12)
            .background(Color.gray.opacity(0.05))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2)))
        .padding(.horizontal)
    }
}

struct TaskRow: View {
    let icon: String
    let title: String
    let reward: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(title).font(.system(size: 15, weight: .medium))
                Text(" \(reward) Coins").font(.caption).foregroundColor(.gray)
            }
            
            Spacer()
            Image(systemName: "arrow.right").font(.footnote).foregroundColor(.gray)
        }
    }
}

struct ActionGrid: View {
    let actions = [
        ("Pay to UPI ID", "book.pages"),
        ("Bills & Recharges", "creditcard.fill"),
        ("Check balance", "a.book.closed"),
        ("History","bahtsign.arrow.trianglehead.counterclockwise.rotate.90")
        
    ]
    @State private var showingHistory = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(actions, id: \.0) { action in
                VStack(spacing: 8) {
                    Image(systemName: action.1)
                        .font(.system(size: 24))
                        .frame(width: 55, height: 55)
                        .background(Circle().fill(Color.white).shadow(radius: 1)).onTapGesture {
                            showingHistory = true
                        }
                    Text(action.0)
                        .font(.system(size: 11))
                        .multilineTextAlignment(.center)
                        
                }
            }.sheet(isPresented: $showingHistory) {
                TransactionHistoryView()
            }
        }
        .padding(.horizontal)
    }
}

struct UpiIdBar: View {
    var body: some View {
        HStack {
            Image(systemName: "qrcodeviewfinder")
            Text("My QR").font(.caption).bold()
            Divider().frame(height: 20)
            Text("xxxxxx@dpI").font(.caption)
            Image(systemName: "doc.on.doc")
            Spacer()
            HStack {
                Image(systemName: "paperplane.fill")
                Text("Try Wallet").font(.caption).bold()
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
        .padding(.horizontal)
    }
}

struct CardSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Linked Cards")
                .font(.caption).bold().foregroundColor(.gray)
            ScrollView{
                HStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.8))
                        .frame(height: 100)
                        .overlay(Text("Kotak Mahindra").foregroundColor(.white)
                            .font(.headline)
                            .padding(), alignment: .topLeading)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.8))
                        .frame(height: 100)
                        .overlay(Text("HDFC Bank").foregroundColor(.white)
                            .font(.headline)
                            .padding(), alignment: .topLeading)
                    
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CustomTabBar: View {
    @State private var showingPayment = false
    var body: some View {
       
        VStack(spacing: 0) {
            Divider()
            HStack {
                TabItem(icon: "house.fill", label: "Home", active: true)
                TabItem(icon: "arrow.left.arrow.right", label: "Payments")
                
                // Central UPI Button
                VStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 60, height: 60)
                        .overlay(Text("UPI").foregroundColor(.white).bold())
                        .offset(y: -20)
                        .onTapGesture {
                                                // 2. Toggle the state to true
                                                showingPayment = true
                                            }
                }
                
                TabItem(icon: "hand.raised.fill", label: "Loans")
                TabItem(icon: "bag.fill", label: "Support")
            }
            .sheet(isPresented: $showingPayment) {
                        PaymentView()
                    }
            .padding(.top, 10)
            .padding(.bottom, 30)
            .background(Color.white)
        }
    }
}

struct TabItem: View {
    let icon: String
    let label: String
    var active: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
            Text(label).font(.caption2)
        }
        .foregroundColor(active ? .red : .gray)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
