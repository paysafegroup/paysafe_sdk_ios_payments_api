//
//  SavedCreditCardPaymentMethodView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments
import SwiftUI

struct SavedCreditCardPaymentMethodView<ViewModel: SavedCreditCardPaymentMethodViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appCoordinator: AppCoordinator

    /// PSCardholderNameInputSwiftUIView
    private var cardholderNameView: PSCardholderNameInputSwiftUIView
    /// PSCardCVVInputSwiftUIView
    private var cardCVVView: PSCardCVVInputSwiftUIView

    init(
        billingAddress: BillingAddress?,
        totalPrice: Double,
        savedCard: SavedCard
    ) {
        viewModel = ViewModel(
            billingAddress: billingAddress,
            totalPrice: totalPrice,
            savedCard: savedCard
        )
        cardholderNameView = PSCardholderNameInputSwiftUIView(cardholderName: savedCard.holderName)
        cardCVVView = PSCardCVVInputSwiftUIView(cardBrand: savedCard.cardBrand)
    }

    var body: some View {
        GeometryReader { reader in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 40) {
                    CheckoutBasicHeaderView(title: "Credit card")
                    if viewModel.isInitializing {
                        loadingView
                        Spacer()
                    } else {
                        savedCreditCardPaymentMethodFormView
                        Spacer()
                        savedCreditCardPaymentMethodButtonsView
                    }
                }
                .padding(.horizontal, 16)
                .frame(minHeight: reader.size.height)
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.presentAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .cancel(Text("OK"))
                )
            }
            .onAppear {
                viewModel.configureCardForm(
                    paymentManager: appCoordinator.paymentManager,
                    cardholderNameView: cardholderNameView,
                    cardCVVView: cardCVVView
                )
            }
            .fullScreenCover(item: $viewModel.orderConfirmationDetails) { orderConfirmationDetails in
                OrderConfirmationView(orderConfirmationDetails: orderConfirmationDetails)
            }
            .transaction { $0.disablesAnimations = true }
        }
    }

    private var savedCreditCardPaymentMethodFormView: some View {
        VStack(spacing: 16) {
            Group {
                SavedCreditCardView(
                    savedCard: viewModel.savedCard,
                    style: .secondary
                )
                cardCVVView
            }
            .frame(height: 80)
        }
    }

    private var savedCreditCardPaymentMethodButtonsView: some View {
        VStack(spacing: 5) {
            PSButton(
                title: "Place order",
                style: .primary,
                isEnabled: viewModel.placeOrderEnabled && !viewModel.isloading,
                isLoading: viewModel.isloading
            ) {
                viewModel.didTapPlaceOrder(using: appCoordinator.paymentManager)
            }
            .accessibilityIdentifier("placeOrderButton")

            PSButton(
                title: "Cancel",
                style: .tertiary
            ) {
                presentationMode.wrappedValue.dismiss()
            }
            .accessibilityIdentifier("cancelButton")
        }
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .ltPurple))
            .scaleEffect(1.5)
            .padding(.vertical, 100)
    }
}

struct SavedCreditCardPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCreditCardPaymentMethodView(
            billingAddress: nil,
            totalPrice: 0.99,
            savedCard: SavedCard(
                cardBrand: .mastercard,
                lastDigits: "2476",
                holderName: "John Doe",
                expiryMonth: 9,
                expiryYear: 2028,
                singleUseCustomerToken: "singleUseCustomerToken",
                paymentTokenFrom: "paymentTokenFrom"
            )
        )
        .environmentObject(AppCoordinator())
    }
}
