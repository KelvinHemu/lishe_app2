package com.lishe.entity;


import com.lishe.models.ActivityLevel;
import com.lishe.models.Age;
import com.lishe.models.Goal;
import com.lishe.models.UserRoles;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;


import java.util.Collection;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "users")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Users implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;

    private String username;
    private String password;
    @Enumerated(EnumType.STRING)
    private UserRoles roles;
    @Enumerated(EnumType.STRING)
    private Goal goal;
    @Enumerated(EnumType.STRING)
    private ActivityLevel level;
    @Enumerated(EnumType.STRING)
    private Age age;
    private String mobile;
    private double height;
    private double weight;
    private double bmiValue;
    private String gender;
    private String dietType;

    @ElementCollection
    @CollectionTable(name = "food_allergies", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "allergies")
    private Set<String> foodAllergies;

    @ElementCollection
    @CollectionTable(name = "favorite_foods", joinColumns = @JoinColumn(name = "user_id"))
    @Column(name = "favorite")
    private Set<String> favoriteFoods;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(roles.name()));
    }

    @Override
    public String getPassword() {
        return username;
    }

    @Override
    public String getUsername() {
        return password;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
