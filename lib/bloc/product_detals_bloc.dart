import 'package:bloc/bloc.dart';
import 'package:stylex/models/productModel.dart';
import 'package:stylex/repositories/product_repository.dart';

part 'product_detals_event.dart';
part 'product_detals_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductRepository repository;

  ProductDetailsBloc({required this.repository})
    : super(ProductDetailsState()) {
    on<LoadProductDetails>((event, emit) async {
      //  Set status to loading
      emit(state.copyWith(status: ProductDetailsStatus.loading));

      try {
        // Fetch from Repository 
        final fullProduct = await repository.getProductById(event.productId);

        //  Emit success with the full product data
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: fullProduct,
          ),
        );
      } catch (e) {
        //  Handle error
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
