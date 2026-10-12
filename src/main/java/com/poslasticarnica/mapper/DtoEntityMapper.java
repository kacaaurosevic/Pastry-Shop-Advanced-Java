package com.poslasticarnica.mapper;

public interface DtoEntityMapper<T, E> {
    T toDto(E e);
    E toEntity(T t);
}
