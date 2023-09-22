//
//  PaymentMethodsView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct PaymentMethodsView<ViewModel: PaymentMethodsViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator

    init(
        billingAddress: BillingAddress?,
        item: ShopItem?,
        totalPrice: Double
    ) {
        viewModel = ViewModel(
            billingAddress: billingAddress,
            item: item,
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
                    paymentMethodsFormView
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
        .onAppear { viewModel.onAppear(using: appCoordinator.paymentManager) }
        .fullScreenCover(item: $viewModel.orderConfirmationDetails) { orderConfirmationDetails in
            OrderConfirmationView(orderConfirmationDetails: orderConfirmationDetails)
        }
    }

    private var paymentMethodsFormView: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.paymentMethods, id: \.self) { paymentMethod in
                paymentMethodView(for: paymentMethod)
                    .frame(height: 80)
            }
        }
    }

    @ViewBuilder
    private func paymentMethodView(for paymentMethod: PaymentMethod) -> some View {
        Group {
            switch paymentMethod {
            case .creditCard:
                NavigationLink(
                    destination: NavigationLazyView(
                        CreditCardPaymentMethodView(
                            billingAddress: viewModel.billingAddress,
                            totalPrice: viewModel.totalPrice
                        )
                    )
                ) {
                    PaymentMethodView(paymentMethod: paymentMethod)
                }
                .accessibilityIdentifier("creditCardPaymentMethodView")
            case .applePay:
                viewModel.applePayContext?.applePaySwiftUIButton(
                    type: .buy,
                    style: .automatic
                ) {
                    viewModel.presentApplePay(using: appCoordinator.paymentManager)
                }
                .padding(.vertical)
                .accessibilityIdentifier("applePayPaymentMethodView")
            case .payPal:
                Button {
                    viewModel.presentPayPal(using: appCoordinator.paymentManager)
                } label: {
                    PaymentMethodView(paymentMethod: paymentMethod)
                }
                .accessibilityIdentifier("payPalPaymentMethodView")
            }
        }
        .disabled(!paymentMethod.isEnabled)
        .buttonStyle(PlainButtonStyle())
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .ltPurple))
            .scaleEffect(1.5)
            .padding(.vertical, 100)
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        let shopItem = ShopItem(
            id: 0,
            title: "Draw Games",
            description: "Draw Games offer an exhilarating opportunity to test your luck and win big by selecting a set of numbers for a chance to match those drawn in the upcoming game. With each ticket, you hold the potential to unlock a jackpot that could turn your dreams into reality.",
            price: 0.99,
            date: Date(),
            iconName: "calendar",
            favourite: true,
            newEntry: true,
            availableQuantity: 10
        )
        PaymentMethodsView(
            billingAddress: nil,
            item: shopItem,
            totalPrice: 0.99
        )
        .environmentObject(AppCoordinator())
    }
}
