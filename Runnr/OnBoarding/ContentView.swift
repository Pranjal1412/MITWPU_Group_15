
import Foundation
import SwiftUI

// Model for an onboarding page that conforms to the Identifiable protocol
struct OnboardingPage: Identifiable {
    let id = UUID() // Unique identifier for each page
    let imageName: String // Name of the image asset to display on the page
    let title: String // Title text for the page
    let description: String // Description text for the page
}

// Main view for the onboarding sequence
struct OnboardingView: View {
    @State private var currentPage = 0 // State variable to track the current page index
    
    private let pages = [ // Array of onboarding pages with their content
        OnboardingPage(
            imageName: "onboarding1",
            title: "Welcome",
            description: "Earn points for every activity you complete. Every effort counts"
        ),
        OnboardingPage(
            imageName: "onboarding2",
            title: "Earn Your Points",
            description: "Your performance determines how much you earn, while Challenges offer bonus points"
        ),
        OnboardingPage(
            imageName: "onboarding3",
            title: "Turn Effort Into Impact",
            description: "Use your points to compete in the Territory Capture game. Claim zones and defend your ground."
        )
    ]
    
    var body: some View { // The content of the view
        VStack { // Arrange elements vertically
            
            // TabView for swiping between onboarding pages
            TabView(selection: $currentPage) { // Bind the selection to the currentPage state variable
                ForEach(0..<pages.count) { index in // Loop through each page index
                    OnboardingPageView(page: pages[index]) // Create the view for each onboarding page
                        .tag(index) // Tag each page with its index for identification
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Use page style without default index indicators
            .animation(.easeInOut, value: currentPage) // Animate transitions when currentPage changes
            
            // Page indicators (dots)
            HStack(spacing: 5) { // Arrange the indicators horizontally with spacing
                ForEach(0..<pages.count) { index in // Loop through each page index
                    Circle() // Create a circle shape for the indicator
                        .fill(currentPage == index ? Color.accentColor : Color.gray.opacity(0.5)) // Color blue if current, else gray with reduced opacity
                        .frame(
                            width: currentPage == index ? 8 : 5,
                            height: currentPage == index ? 8 : 5
                        ) // Larger circle for the current page
                        .animation(.spring(), value: currentPage) // Animate the size change with a spring effect
                }
            }
            .padding(.top, 4)      // instead of vertical 10
            .padding(.bottom, 4) // Add vertical padding around the indicators
            
            // Button to move to the next page or finish onboarding
            //            Button(action: {
            ////                withAnimation(.easeInOut) { // Animate the button action
            ////                    if currentPage < pages.count - 1 { // If not on the last page
            ////                        currentPage += 1 // Go to the next page
            ////                    } else { // If on the last page
            ////                        // Onboarding is complete; transition to the main screen can be implemented here
            ////                        print("Onboarding completed!")
            ////                    }
            ////                }
            ////            }) {
            ////                // Button label: "Next" on intermediate pages, "Get Started" on the last page
            ////                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
            ////                    .foregroundColor(.black) // Set the text color to white
            ////                    .bold() // Make the text bold
            ////                    .padding() // Add padding inside the button
            ////                    .frame(width: 150, height: 45) // Make the button expand to fill the available width
            ////                    .background(Color.accentColor) // Set the button's background color to blue
            ////                    .cornerRadius(15) // Round the corners of the button
            ////                    .padding(.horizontal, 40) // Add horizontal padding
            ////            }
            //            .padding(.bottom, 20)
            //        }
        }
    }
}

// View representing the content of a single onboarding page
struct OnboardingPageView: View {
    let page: OnboardingPage // The onboarding page model for this view
    @State private var animateContent = false // State variable to control the animation of content
    
    var body: some View { // The content of the view
        VStack(spacing: 10) { // Arrange elements vertically with spacing
            
            // Animated image view
            Image(page.imageName) // Load the image from the asset catalog
                .resizable() // Make the image resizable
                .aspectRatio(contentMode: .fit) // Keep the image aspect ratio and fit within its frame
                .frame(height: 100) // Set a fixed height for the image
                .padding(.horizontal) // Add horizontal padding around the image
                .shadow(color: .black.opacity(0.3), radius: 5, x: 3, y: 3) // Apply a shadow to the image
                .opacity(animateContent ? 1 : 0) // Fade in the image based on animation state
                .scaleEffect(animateContent ? 1 : 0.8) // Scale the image for a zoom effect during animation
                .animation(.easeOut(duration: 0.6), value: animateContent) // Animate the image appearance
            
            // Animated title text
            Text(page.title) // Display the title text from the onboarding page
                .font(.title3) // Use a large title font style
                .fontWeight(.bold) // Bold the title text
                .opacity(animateContent ? 1 : 0) // Fade in the title based on animation state
                .offset(y: animateContent ? 0 : 20) // Slide the title vertically during the animation
                .animation(.easeOut(duration: 0.6).delay(0.3), value: animateContent) // Animate the title with a slight delay
            
            // Animated description text
            Text(page.description) // Display the description text from the onboarding page
                .font(.caption) // Use the body font style
                .multilineTextAlignment(.center) // Center-align the text across multiple lines
                .padding(.horizontal, 10) // Add horizontal padding around the description
                .opacity(animateContent ? 1 : 0) // Fade in the description based on animation state
                .offset(y: animateContent ? 0 : 20) // Slide the description vertically during the animation
                .animation(.easeOut(duration: 0.6).delay(0.5), value: animateContent) // Animate the description with a longer delay
        }
        .onAppear { // When the view appears on screen
            animateContent = true // Start the content animations
        }
        .onDisappear { // When the view disappears from the screen
            animateContent = false // Reset the animation state
        }
    }
}
// Main starting view of the application
struct ContentView: View {
    var body: some View { // The content of the view
        ZStack { // Overlay views on top of each other
            //color.color1.ignoresSafeArea() // Set a custom background color that fills the safe area
            OnboardingView() // Display the onboarding sequence on top of the background
        }
    }
}

// Preview provider for Xcode previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View { // Define the preview content
        ContentView() // Preview the main content view
    }
}
           
