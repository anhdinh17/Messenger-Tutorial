//
//  ActiveNowView.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/5/24.
//

import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach( 0 ... 10, id: \.self) { _ in
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(Color(.gray))
                            
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 18, height: 18)
                                
                                Circle()
                                    .fill(.green)
                                    .frame(width: 14, height: 14)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 106)
        .border(.red, width: 1.5)
    }
}

#Preview {
    ActiveNowView()
}
