package com.app.store.service;

import com.app.store.entity.Report;
import com.app.store.entity.User;

import java.util.List;

public interface ReportService {
    Report submitReport(User reporter, Long sellerId, Long orderId, String reason, String description);
    List<Report> getAllReports();
    Report resolveReport(Long reportId);
}
