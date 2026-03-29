import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/branch_booking/data/datasources/booking_remote_data_source.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_request_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/operations_history/data/models/paginated_response.dart';

class BookingRepository {
  final BookingRemoteDataSource remote;

  BookingRepository(this.remote);

  Future<Either<Failure, int>> createRequest(
    AppointmentRequestModel request,
  ) async {
    try {
      final id = await remote.createAppointmentRequest(request);
      return Right(id);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> createAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      await remote.createAppointment(appointment);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ServiceModel>>> getServices() async {
    try {
      final services = await remote.getServices();
      return Right(services);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, PaginatedResponse<AppointmentModel>>> getOperations(
    String? url,
  ) async {
    try {
      final response = await remote.getOperations(url);
      return Right(response);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
