import 'package:equatable/equatable.dart';
import '../../domain/entities/breed_entity.dart';

abstract class BreedState extends Equatable {
  const BreedState();

  @override
  List<Object?> get props => [];
}

class BreedInitial extends BreedState {}

class BreedLoading extends BreedState {}

class BreedLoaded extends BreedState {
  final List<BreedEntity> breeds;

  const BreedLoaded(this.breeds);

  @override
  List<Object?> get props => [breeds];
}

class BreedDetailLoaded extends BreedState {
  final BreedEntity breed;

  const BreedDetailLoaded(this.breed);

  @override
  List<Object?> get props => [breed];
}

class BreedError extends BreedState {
  final String message;

  const BreedError(this.message);

  @override
  List<Object?> get props => [message];
}
