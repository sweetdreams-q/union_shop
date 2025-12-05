# Test Documentation

This directory contains comprehensive test coverage for the Union Shop Flutter application.

## Test Structure

```
test/
├── unit/                 # Unit tests for business logic
│   └── cart_model_test.dart
├── widget/              # Widget tests for UI components
│   ├── home_page_widget_test.dart
│   └── product_cart_search_widget_test.dart
└── integration/         # End-to-end integration tests
    └── app_integration_test.dart
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

### Run Widget Tests Only
```bash
flutter test test/widget/
```

### Run Integration Tests Only
```bash
flutter test test/integration/
```

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Test Coverage Summary

### Unit Tests (test/unit/cart_model_test.dart)
**17 tests covering:**
- CartModel initialization and state
- Adding items to cart (new items, merging duplicates)
- Price calculations with sale items
- Removing items from cart
- Clearing cart
- Change notifications
- Edge cases (zero quantity, invalid prices)

### Widget Tests (test/widget/)

#### home_page_widget_test.dart (10 tests)
- Logo and navigation display
- Product carousel rendering
- Product cards display
- Navigation to Gallery, About, Sale, Search pages
- Footer rendering
- Mobile drawer navigation

#### product_cart_search_widget_test.dart (19 tests)
**Product Page:**
- Product details display (name, price, description, images)
- Sale badge display
- Size selection
- Quantity increment/decrement
- Add to cart functionality

**Cart Page:**
- Empty cart state
- Cart items display
- Remove items from cart
- Total price calculation

**Search Page:**
- Search field functionality
- Product filtering
- Search result highlighting
- No results handling

**Gallery Page:**
- Product grid display
- All products visibility

**Sale Page:**
- Sale items display

**Print Shack Page:**
- Custom product page rendering

### Integration Tests (test/integration/app_integration_test.dart)
**13 end-to-end tests covering:**

**Shopping Flows:**
- Complete purchase journey (browse → view → add → cart)
- Multi-product shopping
- Search and purchase flow
- Sale item purchase

**Navigation:**
- Full app navigation between all pages
- Back navigation handling
- Responsive layout (desktop ↔ mobile)

**Cart Management:**
- Adding multiple items
- Removing items
- Cart state persistence across navigation
- Rapid cart additions

**Edge Cases:**
- Empty search results
- Continue shopping from empty cart
- Back navigation from product page

## Test Best Practices

1. **Isolation**: Each test is independent and doesn't rely on other tests
2. **Setup**: Tests use `pumpWidget` and `pumpAndSettle` for proper rendering
3. **Cleanup**: Widget tests properly dispose resources
4. **Assertions**: Multiple assertions verify expected behavior
5. **Coverage**: Tests cover happy paths, edge cases, and error states

## Known Issues

- Integration tests may take longer to run due to full app initialization
- Some tests require specific screen sizes for responsive layout testing
- Tests assume 4 sample products are defined in the app

## Adding New Tests

### Unit Test Template
```dart
test('description of what is being tested', () {
  // Arrange: Set up test data
  final cart = CartModel();
  
  // Act: Perform the action
  cart.addItem(/* ... */);
  
  // Assert: Verify the result
  expect(cart.itemCount, 1);
});
```

### Widget Test Template
```dart
testWidgets('description of widget behavior', (tester) async {
  await tester.pumpWidget(const UnionShopApp());
  await tester.pumpAndSettle();
  
  // Interact with widgets
  await tester.tap(find.text('Button'));
  await tester.pumpAndSettle();
  
  // Verify expectations
  expect(find.text('Expected Text'), findsOneWidget);
});
```

### Integration Test Template
```dart
testWidgets('description of user flow', (tester) async {
  await tester.pumpWidget(const UnionShopApp());
  await tester.pumpAndSettle();
  
  // Simulate complete user journey
  // Step 1: Navigate
  // Step 2: Interact
  // Step 3: Verify outcome
});
```

## Continuous Integration

To run tests in CI/CD pipeline:

```yaml
- name: Run tests
  run: flutter test --coverage
  
- name: Check coverage
  run: |
    flutter test --coverage
    lcov --list coverage/lcov.info
```

## Troubleshooting

**Problem**: Tests fail with "Null check operator used on a null value"
**Solution**: Ensure Firebase is properly initialized in test setup

**Problem**: Widget not found in tests
**Solution**: Add `await tester.pumpAndSettle()` after navigation

**Problem**: Tests timeout
**Solution**: Increase timeout or check for infinite animations

**Problem**: Integration tests hang
**Solution**: Run tests individually or increase test timeout
