//
//  ContentView.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import SwiftUI
import RealmSwift
import AVFoundation

struct ContentView: View {
    
    let realm = try! Realm()
    @AppStorage ("tabSelection") var tabSelection: Int=0
    @ObservedResults(CounterDataModel.self) var cdms
    @State var showAlert1: Bool = false

    @State var audioSession = AVAudioSession.sharedInstance()
    var vc:VolumeController = VolumeController()

    @ObservedObject var vl = VolumeListener()
    
    var body: some View {
        ZStack (alignment: .bottom) {           
            TabView (selection: $tabSelection) {
                if cdms.count > 0 {
                    ForEach(0..<cdms.count, id:\.self) { index in
                        CounterSingleView(cdm:cdms[index])
                    }
                }
                else
                {
                    Text("Empty")
                        .font(.largeTitle)
                        .padding(.bottom,100)
                }
            }
            .tabViewStyle(.page)
            .ignoresSafeArea()
            
            VStack{
                Button {
                    if vl.audioInteruption {
                        vc.setVolume(0.5)
                        do {
                            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                        vl.falseAudioInteruption()
                    }
                    else{
                        do {
                            try audioSession.setActive(false)
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                        
                        vl.trueAudioInteruption()
                    }
                } label: {
                    Text(vl.audioInteruption ? "Volume Button : Audio" : "Volume Button : Counter")
                        .foregroundColor(.white)
                        .padding(.all,6)
                        .frame(width: 220)
                        .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.white, lineWidth: 1)
                                )
                }
                .padding(.bottom,12)
                HStack{
                    Spacer()
                    Button {
                        try! realm.write {
                            realm.add(CounterDataModel(title: "Counter #\(cdms.count+1)", backColor: "#FFCC00", counted: 0))
                        }
                    } label: {
                        Text("+ New")
                            .padding(.all,6)
                            .frame(width: 100)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(lineWidth: 1)
                                    )
                    }
                    Spacer()
                }
            }.padding(.bottom,36)
        }
        .onAppear{
            vl.setCdmIndex(index: tabSelection)
            print(Realm.Configuration.defaultConfiguration.fileURL!)
             if(cdms.count<1){
                 try! realm.write {
                     realm.add(CounterDataModel(title: "Counter #1", backColor: "#FFCC00", counted: 0))
                 }
             }
        }
        .onChange(of: tabSelection) { newValue in
            vl.setCdmIndex(index: tabSelection)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
