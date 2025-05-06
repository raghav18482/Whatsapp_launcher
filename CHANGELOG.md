# Changelog

## [1.0.0] - 2024-03-19

### Added
- Initial release with basic WhatsApp message launching functionality
- Support for sending immediate messages with pre-filled content
- Added scheduled message feature
  - New `scheduleWhatsAppMessage` method for scheduling messages
  - Support for custom scheduling time using DateTime
  - Error handling for scheduling failures
- Comprehensive documentation and examples
- Support for both Android and iOS platforms

### Features
- Launch WhatsApp with phone number and message
- Schedule messages for future delivery
- Simple and intuitive API
- Error handling and status reporting
- Platform-specific optimizations

### Technical Details
- Minimum SDK version 16 for Android
- iOS 9.0+ support
- Null safety support
- Comprehensive error handling
