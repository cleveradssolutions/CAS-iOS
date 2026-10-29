//
//  CASBidMachineRewardedLoader.swift
//  CASBidMachine
//
//  Copyright © 2026 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import BidMachine
import CleverAdsSolutions

/// BidMachine splits the two steps of a bid: creating the ad runs the auction
/// and answers with its price, `loadAd` then fetches the creative. A Client
/// Bidding request is answered from the first step and fetches the creative
/// only once the bid has won, a Waterfall or Server Bidding request goes
/// through both at once.
final class CASBidMachineLoader: MediationAdBase, MediationAdBid, MediationAdLoader {
    private var request: MediationAdBidRequest?
    private var loadedBid: BidMachineAdProtocol?
    private var loadingAd: CASBidMachineAd?

    /// The creative never leaves the BidMachine request object,
    /// so there is no markup for CAS to carry.
    var bidResponse: String? { "Not used" }

    init(request: MediationAdBidRequest) {
        self.request = request
        super.init()
    }

    func didBidRecieved(_ bid: BidMachineAdProtocol?, error: Error?) {
        guard let bid = bid else {
            self.request?.failure(CASErrorFromBidMachine(error))
            self.request = nil
            return
        }

        costPerMille = bid.auctionInfo.price
        revenuePrecision = AdRevenuePrecision.precise
        
        self.loadedBid = bid
        request?.success(bid: self)
        request = nil
    }

    func loadAdContent(
        request: MediationAdContentRequest,
        secondPrice: Double,
        secondSource: AdSourceId
    ) {
        guard let bid = loadedBid else {
            request.failure(AdError.notReady)
            return
        }

        BidMachineSdk.shared.notifyMediationWin(bid)

        let ad = CASBidMachineAd(request: request)
        loadingAd = ad
        ad.loadAdContent(bid, error: nil)
    }

    func noticeLoss(reason: AuctionNoticeReason, winnerPrice: Double, winnerSource: AdSourceId) {
        if let bid = loadedBid {
            BidMachineSdk.shared.notifyMediationLoss(
                CASNetwork.getDisplayName(id: winnerSource),
                winnerPrice,
                bid
            )
        }
    }
    
    override func destroy() {
        super.destroy()
        loadedBid = nil
        loadingAd = nil
        request = nil
    }
}
