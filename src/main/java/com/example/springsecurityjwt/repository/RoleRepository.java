package com.example.springsecurityjwt.repository;

import com.example.springsecurityjwt.entity.ERole;
import com.example.springsecurityjwt.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(ERole name);
    Boolean existsByName(ERole name);
} 