package com.app.store.controller;

import com.app.store.entity.Role;
import com.app.store.entity.User;
import com.app.store.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/users")
@RequiredArgsConstructor
public class AdminUserController {

    private final UserRepository userRepository;

    @GetMapping
    public String listUsers(Model model) {
        
        List<User> users = userRepository.findByRoleNot(Role.ADMIN);
        model.addAttribute("users", users);
        return "admin/user-list";
    }

    @GetMapping("/{id}/delete")
    public String deleteUser(@PathVariable("id") Long id) {
        try {
            User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("User not found"));
            if (user.getRole() == Role.ADMIN) {
                return "redirect:/admin/users?error=Cannot delete administrator accounts.";
            }

            userRepository.delete(user);
            return "redirect:/admin/users?success=User account deleted successfully.";
        } catch (Exception e) {
            return "redirect:/admin/users?error=Cannot delete user. They may have active orders or products tied to their account.";
        }
    }
}
