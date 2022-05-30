//
//  SignUpView.swift
//  CodeMind
//
//  Created by 三火 on 2022/5/29.
//

import SwiftUI

struct SignUpView: View {
    // Animated Focus State
    enum Field: Hashable {
        case email
        case password
    }
    
    @State var email = ""
    @State var password = ""
    @FocusState var focusedField: Field?
    @State var circleY: CGFloat = 120
    @State var emailY: CGFloat = 0
    @State var passwordY: CGFloat = 0
    @State var circleColor: Color = .blue
    @State var appear = [false, false, false]
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sign up")
                .font(.largeTitle).bold()
                .opacity(appear[0] ? 1 : 0)
                .offset(y: appear[0] ? 0 : 20)
            
            Text("Access 120+ hours of courses, tutorials and livestreams")
                .font(.headline)
                .opacity(appear[1] ? 1 : 0)
                .offset(y: appear[1] ? 0 : 20)
            
            Group {
                // 账户密码输入文本框
                TextField("Email", text: $email)
                // 自定义inputStyle
                    .inputStyle(icon: "mail")
                // 弹出的键盘是专门输入email的
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                // focus绑定
                    .focused($focusedField, equals: .email)
                    .shadow(color: focusedField == .email ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                    .overlay(geometry)
                // 使用测距的数据
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        emailY = value
                        circleY = value
                    }
                
                SecureField("Password", text: $password)
                    .inputStyle(icon: "lock")
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .shadow(color: focusedField == .password ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
                    .overlay(geometry)
                    .onPreferenceChange(CirclePreferenceKey.self) { value in
                        passwordY = value
                    }
                
                
                
                Button { } label: {
                    Text("Create an account")
                        .frame(maxWidth: .infinity)
                }
                .font(.headline)
                .blendMode(.overlay)
                // 自定义ButtonStyle
                .buttonStyle(.angular)
                .tint(.accentColor)
                .controlSize(.large)
                .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
                
                // Can use Text with MarkDown
                
                HStack {
                    Text("By clicking on ")
                    + Text("*Create an account*").foregroundColor(.primary.opacity(0.7))
                    + Text(", you agree to our **Terms of Service** and **[Privacy Policy](https://baidu.com)**")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .accentColor(.secondary)
                
                Divider()
                
                HStack {
                    Text("Already have an account?")
                    Button {
                        model.selectedModal = .signIn
                    } label: {
                        Text("**Sign in**")
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .accentColor(.secondary)
            }
            .opacity(appear[2] ? 1 : 0)
            .offset(y: appear[2] ? 0 : 20)
                        
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        // 选择Email或Password文本框后的小蓝点
        .background(
            Circle().fill(circleColor)
                .frame(width: 68, height: 68)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(y: circleY)
        )
        .coordinateSpace(name: "container")
        
        .strokeStyle(cornerRadius: 30)
        
        // 测距的数据的应用
        .onChange(of: focusedField) { value in
            withAnimation {
                if value == .email {
                    circleY = emailY
                    circleColor = .blue
                } else {
                    circleY = passwordY
                    circleColor = .red
                }
            }
        }
        .onAppear {
            withAnimation(.spring().delay(0.1)) {
                appear[0] = true
            }
            withAnimation(.spring().delay(0.2)) {
                appear[1] = true
            }
            withAnimation(.spring().delay(0.3)) {
                appear[2] = true
            }
        }
    }
    
    // Geometry测距
    var geometry: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: CirclePreferenceKey.self, value: proxy.frame(in: .named("container")).minY)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        // ZStack ==> 消除此版本使用focus state引起的preview problems
        ZStack {
            SignUpView()
                .preferredColorScheme(.light)
                .environmentObject(Model())
        }
    }
}
