//
//  CounterSingleView.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import SwiftUI
import RealmSwift
import UIKit
import AVFoundation

struct CounterSingleView: View {
    let realm = try! Realm()
    var cdm:CounterDataModel
    @State var index:Int = 0

    @State var backColor:Color = .yellow

    @State var editTitle: Bool = false
    @State var inputTitle:String=""

    var body: some View {
        VStack{
            Group{
                if !editTitle{
                    Text("\(cdm.counted)")
                        .font(.system(size:100))
                        .foregroundColor(.white)
                }

                if editTitle{
                    VStack{
                        TextField("Enter your title for this counter", text: $inputTitle)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                        HStack{
                            Button {
                                editTitle = false
                            } label: {
                                Text("CANCEL")
                                    .padding(.all,6)
                                    .frame(width: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(lineWidth: 1)
                                    )
                            }

                            Button {
                                let thawedCdm = cdm.thaw()
                                if let thawedCdm = thawedCdm{
                                    try! realm.write {
                                        thawedCdm.title = inputTitle
                                    }
                                }
                                editTitle = false
                            } label: {
                                Text("SAVE")
                                    .padding(.all,6)
                                    .frame(width: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(lineWidth: 1)
                                    )
                            }

                        }
                    }
                    .padding(.top, 14)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            }
            .padding(.top,70)

            HStack(alignment: .center){
                Text("\(cdm.title)")
                    .font(.title)
                    .foregroundColor(.white)

                Image(systemName:"square.and.pencil")
                    .font(.title2)
                    .foregroundColor(.white)
                    .onTapGesture {
                        editTitle.toggle()
                    }
            }

            VStack{
                HStack{
                    Spacer()
                    Image(systemName: "gobackward")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.trailing,50)
                        .onTapGesture {
                            let thawedCdm = cdm.thaw()
                            if let thawedCdm = thawedCdm{
                                try! realm.write {
                                    thawedCdm.counted = 0
                                }
                            }
                        }
                    ColorPicker(selection:$backColor, supportsOpacity: false) {
                        Text("")
                    }.labelsHidden()
                        .padding(.trailing,50)


                    Image(systemName:"trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .onTapGesture {
                            let thawedCdm = cdm.thaw()
                            if let thawedCdm = thawedCdm{
                                try! realm.write {
                                    realm.delete(thawedCdm)
                                }
                            }
                        }

                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom,15)
            }

//            BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
            BannerAd(unitID: "ca-app-pub-1558971178272615/5890020611")
                .frame(height:100)

            Spacer()
            HStack{
                Spacer()
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .onTapGesture {
                        let thawedCdm = cdm.thaw()
                        if let thawedCdm = thawedCdm{
                            try! realm.write {
                                thawedCdm.counted += 1
                            }
                        }
                    }
            }
//            .padding(.all,30)
            .padding(.top,15)
            .padding(.trailing,30)
            .padding(.bottom,30)
            

            Spacer()
            HStack{
                Spacer()
                Image(systemName: "minus.circle")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .onTapGesture {

                        if ((cdm.counted - 1) < 0) {
                            let thawedCdm = cdm.thaw()
                            if let thawedCdm = thawedCdm{
                                try! realm.write {
                                    thawedCdm.counted = 0
                                }
                            }
                        }
                        else {
                            let thawedCdm = cdm.thaw()
                            if let thawedCdm = thawedCdm{
                                try! realm.write {
                                    thawedCdm.counted -= 1
                                }
                            }
                        }
                    }
            }
            .padding(.all,30)
            .padding(.bottom,160)

            Spacer()
        }
        .onAppear{
            backColor = Color(UIColor(hexCode: cdm.backColor))
        }
        .onChange(of: backColor, perform: { newValue in
            if let hexCode = backColor.toHex() {
                let thawedCdm = cdm.thaw()
                if let thawedCdm = thawedCdm{
                    try! realm.write {
                        thawedCdm.backColor = hexCode
                    }
                }
            }
        })
        .background(Color(UIColor(hexCode: cdm.backColor)))
    }
}

struct CounterSingleView_Previews: PreviewProvider {
    static var previews: some View {
        CounterSingleView(cdm:CounterDataModel())
    }
}
