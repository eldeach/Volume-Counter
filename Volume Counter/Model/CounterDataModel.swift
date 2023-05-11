//
//  CounterDataModel.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import Foundation
import RealmSwift


class CounterDataModel: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title:String = ""
    @Persisted var backColor:String = ""
    @Persisted var counted:Int = 0
    @Persisted var createdDate:Date = Date()
    
    convenience init(title: String, backColor: String, counted: Int) {
        self.init()
        self.title = title
        self.backColor = backColor
        self.counted = counted
        self.createdDate = Date()
    }

}

