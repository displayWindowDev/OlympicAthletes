//
//  MarkDownTextView.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 04/09/23.
//

import SwiftUI

struct MarkDownTextView: View {
    
    var markdownText: LocalizedStringKey?

    var body: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
            Text(self.markdownText ?? "")
                .padding()
                .font(.system(size: 14))
                .foregroundColor(Color("BlueText"))
        })
    }
}

struct MarkDownTextView_Previews: PreviewProvider {
    static var previews: some View {
        MarkDownTextView()
    }
}
