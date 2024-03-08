//
//  NewCreditCardPaymentMethodView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import PaysafeCore
import SwiftUI

struct NewCreditCardPaymentMethodView<ViewModel: NewCreditCardPaymentMethodViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appCoordinator: AppCoordinator

    /// PSCardNumberInputSwiftUIView
    private var cardNumberView: PSCardNumberInputSwiftUIView
    /// PSCardholderNameInputSwiftUIView
    private var cardholderNameView: PSCardholderNameInputSwiftUIView
    /// PSCardExpiryInputSwiftUIView
    private var cardExpiryView: PSCardExpiryInputSwiftUIView
    /// PSCardCVVInputSwiftUIView
    private var cardCVVView: PSCardCVVInputSwiftUIView

    init(
        billingAddress: BillingAddress?,
        totalPrice: Double
    ) {
        viewModel = ViewModel(
            billingAddress: billingAddress,
            totalPrice: totalPrice
        )
        cardNumberView = PSCardNumberInputSwiftUIView()
        cardholderNameView = PSCardholderNameInputSwiftUIView()
        cardExpiryView = PSCardExpiryInputSwiftUIView()
        cardCVVView = PSCardCVVInputSwiftUIView()
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
            viewModel.configureCardForm(
                paymentManager: appCoordinator.paymentManager,
                cardNumberView: cardNumberView,
                cardholderNameView: cardholderNameView,
                cardExpiryView: cardExpiryView,
                cardCVVView: cardCVVView
            )
        }
        .fullScreenCover(item: $viewModel.orderConfirmationDetails) { orderConfirmationDetails in
            OrderConfirmationView(orderConfirmationDetails: orderConfirmationDetails)
        }
        .transaction { $0.disablesAnimations = true }
    }

    private var newCreditCardPaymentMethodFormView: some View {
        VStack(spacing: 16) {
            Group {
                cardNumberView
                cardholderNameView
                cardExpiryView
                cardCVVView
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

    /// Demo purposes
    private mutating func configureEvents() {
        var mutableSelf = self

        cardNumberView.onEvent = { event in
            switch event {
            case .invalid:
                mutableSelf.cardNumberView.theme.backgroundColor = .red
            case .valid:
                mutableSelf.cardNumberView.resetTheme()
            default:
                break
            }
        }

        cardholderNameView.onEvent = { event in
            switch event {
            case .invalid:
                mutableSelf.cardholderNameView.theme.backgroundColor = .red
            case .valid:
                mutableSelf.cardholderNameView.resetTheme()
            default:
                break
            }
        }

        cardExpiryView.onEvent = { event in
            switch event {
            case .invalid:
                mutableSelf.cardExpiryView.theme.backgroundColor = .red
            case .valid:
                mutableSelf.cardExpiryView.resetTheme()
            default:
                break
            }
        }

        cardCVVView.onEvent = { event in
            switch event {
            case .invalid:
                mutableSelf.cardCVVView.theme.backgroundColor = .red
            case .fieldValueChange:
                mutableSelf.cardCVVView.resetTheme()
            default:
                break
            }
        }
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
