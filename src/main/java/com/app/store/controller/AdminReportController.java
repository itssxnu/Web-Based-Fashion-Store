package com.app.store.controller;

import com.app.store.entity.Report;
import com.app.store.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/reports")
@RequiredArgsConstructor
public class AdminReportController {

    private final ReportService reportService;

    @GetMapping
    public String listReports(Model model) {
        List<Report> reports = reportService.getAllReports();
        model.addAttribute("reports", reports);
        return "admin/reports";
    }

    @PostMapping("/resolve")
    public String resolveReport(@RequestParam("reportId") Long reportId, RedirectAttributes redirectAttributes) {
        try {
            reportService.resolveReport(reportId);
            redirectAttributes.addFlashAttribute("successMessage", "Report marked as resolved.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error resolving report: " + e.getMessage());
        }
        return "redirect:/admin/reports";
    }
}
