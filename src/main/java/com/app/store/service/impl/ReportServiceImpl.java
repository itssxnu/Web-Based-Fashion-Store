package com.app.store.service.impl;

import com.app.store.entity.Report;
import com.app.store.entity.User;
import com.app.store.repository.ReportRepository;
import com.app.store.repository.UserRepository;
import com.app.store.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final ReportRepository reportRepository;
    private final UserRepository userRepository;

    @Override
    public Report submitReport(User reporter, Long sellerId, Long orderId, String reason, String description) {
        User reportedSeller = userRepository.findById(sellerId)
                .orElseThrow(() -> new IllegalArgumentException("Seller not found"));

        Report report = Report.builder()
                .reporter(reporter)
                .reportedSeller(reportedSeller)
                .orderId(orderId)
                .reason(reason)
                .description(description)
                .status("PENDING")
                .build();

        return reportRepository.save(report);
    }

    @Override
    public List<Report> getAllReports() {
        return reportRepository.findAllByOrderByCreatedAtDesc();
    }

    @Override
    public Report resolveReport(Long reportId) {
        Report report = reportRepository.findById(reportId)
                .orElseThrow(() -> new IllegalArgumentException("Report not found"));
        
        report.setStatus("RESOLVED");
        return reportRepository.save(report);
    }
}
