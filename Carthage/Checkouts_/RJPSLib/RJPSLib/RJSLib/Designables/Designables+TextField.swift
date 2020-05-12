extension RJSLib.Designables {
    
    public struct InputField {
        private init() { }
        
        public static func madokaTextField(text: String="", placeholder: String="", backgroundColor: UIColor = .white) -> MadokaTextField {
            let some = MadokaTextField()
            some.placeholderColor = .darkGray
            some.borderColor      = .lightGray
            some.backgroundColor  = backgroundColor
            some.text             = text
            some.placeholder      = placeholder
            return some
        }
    }
}
