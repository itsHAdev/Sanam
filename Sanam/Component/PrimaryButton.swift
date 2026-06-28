//
//  PrimaryButton.swift
//  Sanam
//
//  Created by Hadeel on 27/06/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 300, height: 44)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color("darkBlue"))
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color(red: 0.902, green: 0.902, blue: 0.902))
                            .blendMode(.plusDarker)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        }
    }
}
struct WalletButton: View {

    let title: String
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(width: 107,height: 27)
                .background(
                    ZStack {

                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color(red: 0.137, green: 0.235, blue: 0.455))

                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color(red: 0.902, green: 0.902, blue: 0.902))
                            .blendMode(.plusDarker)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .shadow(color: .black.opacity(0.1), radius: 1)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        }
    }
}

struct CircleButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {

        Button{}label: {
            
            ZStack(alignment: .center){
                
                Circle()
                    .frame(width: 44,height: 44)
                    .foregroundStyle(.darkBlue)
                    .shadow(color: .black.opacity(0.1), radius: 1)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                
                Image(systemName: icon)
                    .font(.system(size: 22,weight: .medium))
                    .foregroundStyle(.white)
            }//z
        }
       
    
    }
}

struct SmallButton: View {

    let title: String
    let action: () -> Void

    var body: some View {

        Button(action: action) {
            
            ZStack{
                
                Rectangle()
                    .frame(width: 107,height: 27)
                    .foregroundStyle(.darkBlue)
                    .cornerRadius(100)
                    .shadow(color: .black.opacity(0.1), radius: 1)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                
                Text(title)
                    .font(.system(size: 14,weight: .semibold))
                    .foregroundStyle(.textApp)
            
            }//z
        }//b
    
    }
}


//طريقة استخدامه
/**
 
 PrimaryButton(title: "انتهيت") {
     vm.didTapDone()
 }

 PrimaryButton(title: "تأكيد التوزيع") {
     vm.confirm()
 }

 PrimaryButton(title: "اجمع") {
     vm.collectReward()
 }
 
 */
