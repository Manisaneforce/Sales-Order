import SwiftUI

struct MainView: View {

    @State private var isActive = false

    var body: some View {

        NavigationView{

            

            

            VStack{

                //Your Plan Button

                NavigationLink(destination:

                                Text("YES"), isActive: $isActive){

                    Button(action: {

                        isActive = true

                    }){

                        VStack{

                            Image(systemName: "book.fill")

                            Text("Your Plan")

                            

                        }

                        .font(.system(size: 30, weight: .semibold))

                        .foregroundColor(.green)

                        .padding(.bottom, 40)

                    }

                                    

                                }

                //TrainingSplit Button

                NavigationLink(destination:

                                TrainingSplitView(), isActive: $isActive){

                    Button(action: {

                        isActive = true

                    }){

                        VStack{

                            Image(systemName: "flame.fill")

                            Text("Training Splits")

                            

                        }

                        .font(.system(size: 30, weight: .semibold))

                        .foregroundColor(.green)

                        .padding(.bottom, 40)

                    }

                                }

                //Education Button

                NavigationLink(destination:

                                Text("YES"), isActive: $isActive){

                    Button(action: {

                        isActive = true

                    }){

                        VStack{

                            Image(systemName: "textformat.123")

                            Text("Education")

                            

                        }

                        .font(.system(size: 30, weight: .semibold))

                        .foregroundColor(.green)

                        .padding(.bottom, 40)

                    }

                                    

                                }

                

                //Nutrition Button

                NavigationLink(destination:

                                Text("YES"), isActive: $isActive){

                    Button(action: {

                        isActive = true

                    }){

                        VStack{

                            Image(systemName: "chart.pie.fill")

                            Text("Nutrition")

                            

                        }

                        .font(.system(size: 30, weight: .semibold))

                        .foregroundColor(.green)

                        .padding(.bottom, 40)

                    }

                                }

                //Your Coach Button

                NavigationLink(destination:

                                Text("YES"), isActive: $isActive){

                    Button(action: {

                        isActive = true

                    }){

                        VStack{

                            Image(systemName: "person.fill")

                            Text("Your Coach")

                            

                        }

                        .font(.system(size: 30, weight: .semibold))

                        .foregroundColor(.green)

                        .padding(.bottom, 40)

                    }

                }

                Spacer().frame(height:100)

            }

        }

        .navigationBarBackButtonHidden(true)

        

    }

}
