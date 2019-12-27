//
//  Prompt.swift
//  Tennis Anyone Swift
//
//  Created by George Breen on 12/24/19.
//  Copyright © 2019 George Breen. All rights reserved.
//

import SwiftUI

struct Prompt: View {
    var promptImage: String
    var promptColor: Color
    var promptText: String
    var body: some View {
        HStack {
//            Spacer()
            Image(systemName: promptImage)
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .frame(width: 60.0)
                .shadow(radius: 3.0)
            Spacer()
            Text(promptText)
                .font(.title)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color.white)
                .shadow(radius: 2.0)
                .frame(alignment: . trailing)
            Spacer()
        }
        .frame(alignment: .leading)
        .background(promptColor)
        .listRowInsets(EdgeInsets())
        
        
    }
}

struct ErrorPrompt: View {
    var errorString: String
    var body: some View {
        Prompt(promptImage: "xmark.octagon", promptColor: Color(Constants.redBackgroundColor), promptText: errorString )
    }
}
struct WarningPrompt: View {
    var errorString: String
    var body: some View {
        Prompt(promptImage: "exclamationmark.triangle", promptColor: Color(Constants.yellowBackgroundColor), promptText: errorString )
    }
}

struct GentlePrompt: View {
    var errorString: String
    var promptImage: String
    var body: some View {
        Prompt(promptImage: promptImage, promptColor: Color(Constants.blueBackgroundColor), promptText: errorString )
    }
}

struct Prompt_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            ErrorPrompt(errorString: "This is a test example string to see if this works")
            WarningPrompt(errorString: "This is a warning message to encourage user to correct something")
            GentlePrompt(errorString: "This is the second test to encouge people to press the picture above that looks like this one", promptImage: "plus.circle")
        }
        
    }
}
