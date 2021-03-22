//
//  ContentView.swift
//  beat-tap WatchKit Extension
//
//  Created by Marc Westermann on 15/08/2020.
//
import SwiftUI

struct ContentView: View {
    @State var tapCount : Int = 0
    @State var startTime: Date = Date()
    @State var bpm : String = "0"
    
    @State private var reset = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                if self.reset {
                    WKInterfaceDevice.current().play(.stop)
                    
                    self.reset = false
                    self.tapCount = 0
                    self.bpm = "0"
                } else {
                    WKInterfaceDevice.current().play(.click)
                    handleTap()
                    
                }
                    }) {
                ZStack {
                    Circle().foregroundColor(.green)
                    if bpm == "0" {
                        Image.init(systemName: "metronome").font(.largeTitle).colorInvert()
                    } else if bpm != "0" {
                        VStack(alignment: HorizontalAlignment.center) {
                            Text(String(self.bpm)).font(Font.system(.largeTitle, design: .rounded).monospacedDigit()).colorInvert()
                            Text(String("bpm")).colorInvert()
                        }
                    }
                }
            }.buttonStyle(PlainButtonStyle()).simultaneousGesture(LongPressGesture().onEnded { _ in
                    self.reset = true

            })
            .buttonStyle(PlainButtonStyle())
            
            
                if self.tapCount <= 1 {
                    Text("Tap to measure")
                        .padding(.bottom).transition(.move(edge: .bottom)).animation(.easeOut(duration: 0.01))
                    }
                
                if self.tapCount > 32 {
                    Text("Hold to reset")
                        .padding(.bottom).transition(.move(edge: .bottom)).animation(.easeIn(duration: 0.01))
                    }
            
            
            
        }.edgesIgnoringSafeArea(.bottom).navigationBarTitle("beat-tap").navigationBarBackButtonHidden(true)
    }
    
    func handleTap() -> Void {
        
        self.tapCount += 1
        
        if self.tapCount == 1 {
            self.startTime = Date()
        } else if self.tapCount > 1 {
            calculateBPM()
        }
    }
    
    func calculateBPM() -> Void {
        let currentTime = Date()
        let elapsedMs =  currentTime.timeIntervalSince(self.startTime) * 1000

        
        let accurateBpm  = Double(self.tapCount) * (60000 / elapsedMs)
        self.bpm = String(format: "%.0f", accurateBpm)
        print(tapCount, ";", elapsedMs, ";", accurateBpm, ";", self.bpm)
    }
        
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
