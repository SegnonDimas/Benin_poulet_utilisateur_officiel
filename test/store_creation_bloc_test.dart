import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';

void main() {
  group('StoreCreationBloc', () {
    late StoreCreationBloc bloc;

    setUp(() {
      bloc = StoreCreationBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be StoreCreationInitial', () {
      expect(bloc.state, isA<StoreCreationInitial>());
    });

    test('should emit StoreCreationLoading when StoreCreationSubmit is added',
        () {
      // Arrange
      final expectedStates = [
        isA<StoreCreationLoading>(),
      ];

      // Act & Assert
      expectLater(
        bloc.stream,
        emitsInOrder(expectedStates),
      );

      bloc.add(StoreCreationSubmit());
    });

    test('should emit StoreCreationError when error occurs', () {
      // Arrange
      final expectedStates = [
        isA<StoreCreationLoading>(),
        isA<StoreCreationError>(),
      ];

      // Act & Assert
      expectLater(
        bloc.stream,
        emitsInOrder(expectedStates),
      );

      bloc.add(StoreCreationSubmit());
    });

    test('should update state when SubmitStoreInfo is added', () {
      // Arrange
      final event = SubmitStoreInfo(
        storeName: 'Test Store',
        storePhoneNumber: '+22912345678',
        storeEmail: 'test@example.com',
      );

      // Act
      bloc.add(event);

      // Assert
      expect(bloc.state, isA<StoreCreationGlobalState>());
      final state = bloc.state as StoreCreationGlobalState;
      expect(state.storeName, 'Test Store');
      expect(state.storePhoneNumber, '+22912345678');
      expect(state.storeEmail, 'test@example.com');
    });

    test('should update state when SubmitSectoreInfo is added', () {
      // Arrange
      final event = SubmitSectoreInfo(
        storeSectors: ['Alimentation'],
        storeSubSectors: ['Viande'],
      );

      // Act
      bloc.add(event);

      // Assert
      expect(bloc.state, isA<StoreCreationGlobalState>());
      final state = bloc.state as StoreCreationGlobalState;
      expect(state.storeSectors, ['Alimentation']);
      expect(state.storeSubSectors, ['Viande']);
    });

    test('should update state when SubmitPaymentInfo is added', () {
      // Arrange
      final event = SubmitPaymentInfo(
        storeFiscalType: 'Particulier',
        paymentMethod: 'MTN',
        paymentPhoneNumber: '+22912345678',
        payementOwnerName: 'John Doe',
      );

      // Act
      bloc.add(event);

      // Assert
      expect(bloc.state, isA<StoreCreationGlobalState>());
      final state = bloc.state as StoreCreationGlobalState;
      expect(state.storeFiscalType, 'Particulier');
      expect(state.paymentMethod, 'MTN');
      expect(state.paymentPhoneNumber, '+22912345678');
      expect(state.payementOwnerName, 'John Doe');
    });

    test('should update state when SubmitDeliveryInfo is added', () {
      // Arrange
      final event = SubmitDeliveryInfo(
        sellerOwnDeliver: true,
        location: 'Cotonou',
        locationDescription: 'Zone 4',
      );

      // Act
      bloc.add(event);

      // Assert
      expect(bloc.state, isA<StoreCreationGlobalState>());
      final state = bloc.state as StoreCreationGlobalState;
      expect(state.sellerOwnDeliver, true);
      expect(state.location, 'Cotonou');
      expect(state.locationDescription, 'Zone 4');
    });

    test('should emit StoreCreationError when error event is added', () {
      // Arrange
      final errorMessage = 'Test error message';
      final event = StoreCreationErrorEvent(erroMessage: errorMessage);

      // Act & Assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<StoreCreationError>(),
        ]),
      );

      bloc.add(event);
    });

    test('should emit StoreCreationSuccess when success event is added', () {
      // Arrange
      final event = StoreCreationSuccessEvent();

      // Act & Assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<StoreCreationSuccess>(),
        ]),
      );

      bloc.add(event);
    });
  });
}

