//
//  NewCreditCardPaymentMethodView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCardPayments
import SwiftUI

struct NewCreditCardPaymentMethodView<ViewModel: NewCreditCardPaymentMethodViewModel>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appCoordinator: AppCoordinator

    init(
        billingAddress: BillingAddress?,
        totalPrice: Double
    ) {
        _viewModel = StateObject(
            wrappedValue: ViewModel(
                billingAddress: billingAddress,
                totalPrice: totalPrice
            )
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                CheckoutBasicHeaderView(title: "Credit card")
                    .onTapGesture(count: 2) {
                        viewModel.didDoubleTap()
                    }
                    .onTapGesture(count: 1) {
                        viewModel.didSingleTap()
                    }
                if viewModel.isInitializing {
                    loadingView
                } else {
                    newCreditCardPaymentMethodFormView
                    newCreditCardPaymentMethodButtonsView
                }
            }
            .padding(.horizontal, 16)
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
            viewModel.configureCardForm(paymentManager: appCoordinator.paymentManager)
        }
        .fullScreenCover(item: $viewModel.orderConfirmationDetails) { orderConfirmationDetails in
            OrderConfirmationView(orderConfirmationDetails: orderConfirmationDetails)
        }
        .transaction { $0.disablesAnimations = true }
    }

    private var newCreditCardPaymentMethodFormView: some View {
        VStack(spacing: 16) {
            Group {
                viewModel.cardNumberView
                viewModel.cardholderNameView
                viewModel.cardExpiryView
                viewModel.cardCVVView
            }
            .frame(height: 80)
        }
    }

    private var newCreditCardPaymentMethodButtonsView: some View {
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

struct NewCreditCardPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        NewCreditCardPaymentMethodView(
            billingAddress: nil,
            totalPrice: 0.99
        )
        .environmentObject(AppCoordinator())
    }
}
