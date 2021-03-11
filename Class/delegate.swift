//
//  delegate.swift
//  ScheduleImage
//
//  Created by 八幡尚希 on 2021/03/11.
//

import Foundation
//カスタムplanviewをクリックした際に、そのviewはcontrollerではないため、親から飛ばないとイケナイため。
protocol PlanCustomViewTransitionDelegate {
    func test(plan: Plan)
}

//planをeditして保存した際に、ポップアップのためviewdidappearが呼ばれないため。
protocol EditPlanProtocol {
    func viewDidDismiss()
}

//スケジュールを作成してから真ん中のタブに再び戻ると、secondDisplayがtrueなので、falseに変更するため。
protocol CreateScheduleViewDelegate {
    func goBack()
}

protocol EditScheduleProtocol {
    func viewDidDismiss()
}
