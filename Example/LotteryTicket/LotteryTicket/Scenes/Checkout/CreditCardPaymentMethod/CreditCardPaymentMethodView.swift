//
//  CreditCardPaymentMethodView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct CreditCardPaymentMethodView<ViewModel: CreditCardPaymentMethodViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    init(
        billingAddress: BillingAddress?,
        totalPrice: Double
    ) {
        viewModel = ViewModel(
            billingAddress: billingAddress,
            totalPrice: totalPrice
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                CheckoutBasicHeaderView(title: "Payment method")
                if viewModel.isloading {
                    loadingView
                } else {
                    creditCardPaymentMethodFormView
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
    }

    private var creditCardPaymentMethodFormView: some View {
        VStack(spacing: 16) {
            addNewCreditCardView
            savedCreditCardsView
        }
    }

    private var addNewCreditCardView: some View {
        NavigationLink(
            destination: NavigationLazyView(
                NewCreditCardPaymentMethodView(
                    billingAddress: viewModel.billingAddress,
                    totalPrice: viewModel.totalPrice
                )
            )
        ) {
            AddNewCreditCardView()
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 80)
        .accessibilityIdentifier("addNewCreditCardView")
    }

    private var savedCreditCardsView: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.savedCards, id: \.self) { savedCard in
                savedCreditCardView(for: savedCard)
                    .frame(height: 80)
            }
        }
    }

    private func savedCreditCardView(for savedCard: SavedCard) -> some View {
        NavigationLink(
            destination: NavigationLazyView(
                SavedCreditCardPaymentMethodView(
                    billingAddress: viewModel.billingAddress,
                    totalPrice: viewModel.totalPrice,
                    savedCard: savedCard
                )
            )
        ) {
            SavedCreditCardView(
                savedCard: savedCard,
                style: .primary
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("savedCreditCardView\(savedCard.accessibilityIdentifier)")
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .ltPurple))
            .scaleEffect(1.5)
            .padding(.vertical, 100)
    }
}

struct CreditCardPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardPaymentMethodView(
            billingAddress: nil,
            totalPrice: 0.99
        )
    }
}
