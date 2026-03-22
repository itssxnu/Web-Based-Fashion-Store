package com.app.store.service;

import com.app.store.entity.Category;
import com.app.store.entity.Product;
import com.app.store.entity.ProductVariant;
import com.app.store.entity.StorePolicy;
import com.app.store.repository.CategoryRepository;
import com.app.store.repository.OrderItemRepository;
import com.app.store.repository.ProductRepository;
import com.app.store.repository.StorePolicyRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OpenRouterChatService {

    @Value("${openrouter.api.key}")
    private String apiKey;

    @Value("${openrouter.model}")
    private String modelId;

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final StorePolicyRepository storePolicyRepository;
    private final OrderItemRepository orderItemRepository;
    private final RestTemplate restTemplate;

    public OpenRouterChatService(ProductRepository productRepository, CategoryRepository categoryRepository,
            StorePolicyRepository storePolicyRepository, OrderItemRepository orderItemRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.storePolicyRepository = storePolicyRepository;
        this.orderItemRepository = orderItemRepository;
        this.restTemplate = new RestTemplate();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = true)
    public String generateChatResponse(List<Map<String, String>> conversationHistory) {
        String apiUrl = "https://openrouter.ai/api/v1/chat/completions";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        headers.set("Authorization", "Bearer " + apiKey);
        headers.set("HTTP-Referer", "http://localhost:8085");
        headers.set("X-Title", "QuickCart Store");

        
        String systemPrompt = buildSystemPrompt();

        List<Map<String, String>> messages = new ArrayList<>();
        
        messages.add(Map.of("role", "system", "content", systemPrompt));
        
        messages.addAll(conversationHistory);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", modelId);
        requestBody.put("messages", messages);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        try {
            Map<String, Object> response = restTemplate.postForObject(apiUrl, entity, Map.class);
            if (response != null && response.containsKey("choices")) {
                List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
                if (!choices.isEmpty()) {
                    Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
                    return (String) message.get("content");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "I'm sorry, my AI processing core is currently experiencing technical difficulties processing that request. Please try again later.";
        }

        return "I couldn't process that request at this time.";
    }

    private String buildSystemPrompt() {
        StringBuilder sb = new StringBuilder();
        sb.append("You are QuickCart's friendly and helpful AI Shopping Assistant. ");
        sb.append("Your name is 'QC Assistant'. You operate like a highly knowledgeable store employee. ");
        sb.append(
                "Be polite, helpful, and eager to assist shoppers. Do not explicitly state you are an AI unless asked. ");
        sb.append(
                "Below is the CURRENT LIVE INVENTORY of the QuickCart store pulled directly from the SQL database. You must ONLY recommend products that exist in this list. ");
        sb.append(
                "If a customer asks for a product not in this list, politely inform them we don't carry it right now, and suggest the closest alternative available.\n\n");

        sb.append("--- STORE POLICIES & KNOWLEDGE BASE ---\n");
        sb.append(
                "These are absolute rules. You must strictly adhere to this information if a customer asks. If a policy isn't listed here, tell the customer you don't have access to that information and they should contact human support.\n");
        List<StorePolicy> policies = storePolicyRepository.findAll();
        for (StorePolicy p : policies) {
            sb.append("- ").append(p.getTopic()).append(": ").append(p.getContent()).append("\n");
        }

        sb.append("\n--- STORE CATEGORIES ---\n");
        List<Category> categories = categoryRepository.findAll();
        for (Category c : categories) {
            sb.append("- ").append(c.getName()).append(": ")
                    .append(c.getDescription() != null ? c.getDescription() : "").append("\n");
        }

        sb.append("\n--- TOP SELLING ITEMS ANALYTICS ---\n");
        sb.append(
                "These are current best-sellers. Use this data to recommend popular items when the user asks for suggestions:\n");
        List<Object[]> bestSellers = orderItemRepository.findBestSellingProducts();
        for (Object[] row : bestSellers) {
            sb.append("- ").append(row[0]).append(" (Total Sold: ").append(row[1]).append(" units)\n");
        }

        sb.append("\n--- AVAILABLE PRODUCTS INVENTORY ---\n");
        List<Product> products = productRepository.findAll();
        for (Product p : products) {
            sb.append("ID: ").append(p.getId())
                    .append(" | Title: '").append(p.getTitle()).append("'")
                    .append(" | Category: ").append(p.getCategory())
                    .append(" | Base Price: LKR ").append(p.getBasePrice())
                    .append(" | Desc: ").append(p.getDescription()).append("\n");

            if (p.getVariants() != null && !p.getVariants().isEmpty()) {
                sb.append("   -> Variants Available:\n");
                for (ProductVariant v : p.getVariants()) {
                    sb.append("      - Size: ").append(v.getSize())
                            .append(", Color: ").append(v.getColor())
                            .append(", Quantity in Stock: ").append(v.getStockQuantity())
                            .append(v.getStockQuantity() == 0 ? " (SOLD OUT)" : "")
                            .append("\n");
                }
            } else {
                sb.append("   -> No specific variants defined (One size fits all / Default)\n");
            }
        }

        sb.append("\nINSTRUCTIONS:\n");
        sb.append("1. Answer questions based STRICTLY on the inventory provided above.\n");
        sb.append("2. When mentioning prices, ALWAYS format as 'LKR <price>'.\n");
        sb.append("3. Keep responses relatively concise as they will be displayed in a small floating chat widget.\n");
        sb.append(
                "4. If they ask about stock or sizes, assume we have general stock available unless otherwise specified.\n");
        sb.append(
                "5. Guide the customer. If they just say 'hello', greet them and outline what categories of clothing we carry.\n");

        return sb.toString();
    }
}
