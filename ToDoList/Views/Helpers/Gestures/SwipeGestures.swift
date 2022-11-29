import SwiftUI

struct SwipeGesture: UIViewRepresentable {
    
    @Binding var selector: Int
    
    func makeCoordinator() -> SwipeGesture.Coordinator {
        return SwipeGesture.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SwipeGesture>) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let left = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.left))
        left.direction = .left
        
        let right = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.right))
        right.direction = .right
        
        view.addGestureRecognizer(left)
        view.addGestureRecognizer(right)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SwipeGesture>) {
        
    }
    
    class Coordinator: NSObject{
        
        var parent : SwipeGesture
        
        init(parent1 : SwipeGesture){
            parent = parent1
        }
        
        @objc func left(){
            parent.selector = parent.selector + 1
        }
        
        @objc func right(){
            parent.selector = parent.selector - 1
        }
    }
}
