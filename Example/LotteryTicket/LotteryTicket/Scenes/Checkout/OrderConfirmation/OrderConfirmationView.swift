//
//  OrderConfirmationView.swift
//  LotteryTicket
//
//  Copyright (c) 2024 Paysafe Group
//

import SwiftUI

struct OrderConfirmationView<ViewModel: OrderConfirmationViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator

    init(orderConfirmationDetails: OrderConfirmationDetails) {
        viewModel = ViewModel(
            orderConfirmationDetails: orderConfirmationDetails
        )
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            orderConfirmationHeaderView
            orderConfirmationDetailsView
            Spacer()
            keepShoppingButton
        }
        .padding(.horizontal, 16)
    }

    private var orderConfirmationHeaderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image("orderConfirmation.checkmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
            PSText("Thank you for your order")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var orderConfirmationDetailsView: some View {
        VStack(alignment: .leading, spacing: 25) {
            orderConfirmationDetailView(
                title: "Account id:",
                subtitle: viewModel.orderConfirmationDetails.accountId
            )
            orderConfirmationDetailView(
                title: "Merchant reference number:",
                subtitle: viewModel.orderConfirmationDetails.merchantRefNum
            )
            orderConfirmationDetailView(
                title: "Payment handle token:",
                subtitle: viewModel.orderConfirmationDetails.paymentHandleToken
            )
        }
    }

    private func orderConfirmationDetailView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            PSText(title)
                .font(.system(size: 17, weight: .regular))
            PSText(subtitle)
                .font(.system(size: 17, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var keepShoppingButton: some View {
        PSButton(title: "Keep shopping", style: .primary) {
            appCoordinator.start()
        }
        .padding(.vertical, 30)
    }
}

struct OrderConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        OrderConfirmationView(
            orderConfirmationDetails: OrderConfirmationDetails(
                accountId: "accountId",
                merchantRefNum: "merchantRefNum",
                paymentHandleToken: "paymentHandleToken"
            )
        )
    }
}
