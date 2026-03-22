package com.app.store.controller;

import com.app.store.entity.StorePolicy;
import com.app.store.repository.StorePolicyRepository;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/policies")
@PreAuthorize("hasRole('ADMIN')")
public class AdminStorePolicyController {

    private final StorePolicyRepository storePolicyRepository;

    public AdminStorePolicyController(StorePolicyRepository storePolicyRepository) {
        this.storePolicyRepository = storePolicyRepository;
    }

    @GetMapping
    public String listPolicies(Model model) {
        model.addAttribute("policies", storePolicyRepository.findAll());
        model.addAttribute("newPolicy", new StorePolicy());
        return "admin/policy-list";
    }

    @PostMapping("/new")
    public String createPolicy(@ModelAttribute StorePolicy policy, RedirectAttributes redirectAttributes) {
        try {
            storePolicyRepository.save(policy);
            redirectAttributes.addAttribute("success",
                    "Successfully added rule to AI Knowledge Base: " + policy.getTopic());
        } catch (Exception e) {
            redirectAttributes.addAttribute("error", "Failed to add Rule. Note: Topics must be unique.");
        }
        return "redirect:/admin/policies";
    }

    @GetMapping("/{id}/delete")
    public String deletePolicy(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            storePolicyRepository.deleteById(id);
            redirectAttributes.addAttribute("success", "Successfully purged rule from AI Knowledge Base.");
        } catch (Exception e) {
            redirectAttributes.addAttribute("error", "Error removing rule.");
        }
        return "redirect:/admin/policies";
    }
}
