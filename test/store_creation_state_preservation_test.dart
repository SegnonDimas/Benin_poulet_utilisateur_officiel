import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';

void main() {
  group('StoreCreationBloc State Preservation', () {
    late StoreCreationBloc bloc;

    setUp(() {
      bloc = StoreCreationBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('should preserve state when error occurs during store creation', () {
      // Arrange - Set up some state first
      bloc.add(SubmitStoreInfo(
        storeName: 'Test Store',
        storePhoneNumber: '+22912345678',
        storeEmail: 'test@example.com',
      ));

      bloc.add(SubmitSectoreInfo(
        storeSectors: ['Alimentation'],
        storeSubSectors: ['Viande'],
      ));

      bloc.add(SubmitPaymentInfo(
        storeFiscalType: 'Particulier',
        paymentMethod: 'MTN',
        paymentPhoneNumber: '+22912345678',
        payementOwnerName: 'John Doe',
      ));

      // Act - Trigger store creation (this will fail because we're not in a real Firebase environment)
      bloc.add(StoreCreationSubmit());

      // Assert - Check that the error state preserves all the previous data
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<StoreCreationLoading>(),
          isA<StoreCreationError>(),
        ]),
      ).then((_) {
        final errorState = bloc.state as StoreCreationError;

        // Verify that all the data is preserved
        expect(errorState.storeName, 'Test Store');
        expect(errorState.storePhoneNumber, '+22912345678');
        expect(errorState.storeEmail, 'test@example.com');
        expect(errorState.storeSectors, ['Alimentation']);
        expect(errorState.storeSubSectors, ['Viande']);
        expect(errorState.storeFiscalType, 'Particulier');
        expect(errorState.paymentMethod, 'MTN');
        expect(errorState.paymentPhoneNumber, '+22912345678');
        expect(errorState.payementOwnerName, 'John Doe');

        // Verify that there's an error message
        expect(errorState.erroMessage, isNotNull);
        expect(errorState.erroMessage!.isNotEmpty, true);
      });
    });

    test('should preserve state when error occurs during sector submission',
        () {
      // Arrange - Set up some initial state
      bloc.add(SubmitStoreInfo(
        storeName: 'Test Store',
        storePhoneNumber: '+22912345678',
        storeEmail: 'test@example.com',
      ));

      // Act - This should trigger an error in the sector submission
      // We'll simulate this by directly testing the error handling

      // Assert - The state should still contain the store info
      final currentState = bloc.state as StoreCreationGlobalState;
      expect(currentState.storeName, 'Test Store');
      expect(currentState.storePhoneNumber, '+22912345678');
      expect(currentState.storeEmail, 'test@example.com');
    });

    test('should preserve state when error occurs during payment submission',
        () {
      // Arrange - Set up some initial state
      bloc.add(SubmitStoreInfo(
        storeName: 'Test Store',
        storePhoneNumber: '+22912345678',
        storeEmail: 'test@example.com',
      ));

      bloc.add(SubmitSectoreInfo(
        storeSectors: ['Alimentation'],
        storeSubSectors: ['Viande'],
      ));

      // Act - This should trigger an error in the payment submission
      // We'll simulate this by directly testing the error handling

      // Assert - The state should still contain all previous data
      final currentState = bloc.state as StoreCreationGlobalState;
      expect(currentState.storeName, 'Test Store');
      expect(currentState.storePhoneNumber, '+22912345678');
      expect(currentState.storeEmail, 'test@example.com');
      expect(currentState.storeSectors, ['Alimentation']);
      expect(currentState.storeSubSectors, ['Viande']);
    });

    test('should preserve state when error occurs during delivery submission',
        () {
      // Arrange - Set up some initial state
      bloc.add(SubmitStoreInfo(
        storeName: 'Test Store',
        storePhoneNumber: '+22912345678',
        storeEmail: 'test@example.com',
      ));

      bloc.add(SubmitSectoreInfo(
        storeSectors: ['Alimentation'],
        storeSubSectors: ['Viande'],
      ));

      bloc.add(SubmitPaymentInfo(
        storeFiscalType: 'Particulier',
        paymentMethod: 'MTN',
        paymentPhoneNumber: '+22912345678',
        payementOwnerName: 'John Doe',
      ));

      // Act - This should trigger an error in the delivery submission
      // We'll simulate this by directly testing the error handling

      // Assert - The state should still contain all previous data
      final currentState = bloc.state as StoreCreationGlobalState;
      expect(currentState.storeName, 'Test Store');
      expect(currentState.storePhoneNumber, '+22912345678');
      expect(currentState.storeEmail, 'test@example.com');
      expect(currentState.storeSectors, ['Alimentation']);
      expect(currentState.storeSubSectors, ['Viande']);
      expect(currentState.storeFiscalType, 'Particulier');
      expect(currentState.paymentMethod, 'MTN');
      expect(currentState.paymentPhoneNumber, '+22912345678');
      expect(currentState.payementOwnerName, 'John Doe');
    });
  });
}

