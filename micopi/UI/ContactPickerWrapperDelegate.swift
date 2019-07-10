import Foundation.NSObject

protocol ContactPickerWrapperDelegate: NSObjectProtocol {
    
    /*!
     * @abstract    Invoked when the picker is closed.
     * @discussion  The picker will be dismissed automatically
     *              after a contact or property is picked.
     */
    func contactPickerWrapperDidCancel(
        _ pickerWrapper: ContactPickerWrapper
    )
    
    /*!
     * @abstract    Singular delegate methods.
     * @discussion  These delegate methods will be invoked
     *              when the user selects a single contact or property.
     */
    func contactPickerWrapper(
        _ pickerWrapper: ContactPickerWrapper,
        didSelect contactWrapper: ContactHashWrapper
    )
    
    /*!
     * @abstract    Plural delegate methods.
     * @discussion  These delegate methods will be invoked
     *              when the user is done selecting multiple contacts
     *              or properties.
     *              Implementing one of these methods
     *              will configure the picker for multi-selection.
     */
    func contactPickerWrapper(
        _ pickerWrapper: ContactPickerWrapper,
        didSelect contactWrappers: [ContactHashWrapper]
    )
    
}
