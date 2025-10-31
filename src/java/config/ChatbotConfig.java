package config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ChatbotConfig {
    private static Properties properties = new Properties();

    static {
        try (InputStream input = ChatbotConfig.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // OpenRouter API Configuration
    public static String getApiKey() {
        String key = properties.getProperty("openrouter.api.key");
        if (key == null || key.trim().isEmpty()) {
            throw new IllegalStateException("OpenRouter API key not configured in config.properties");
        }
        return key;
    }

    public static String getBaseUrl() {
        return properties.getProperty("openrouter.base.url", "https://openrouter.ai/api/v1/chat/completions");
    }

    public static String getModel() {
        return properties.getProperty("openrouter.model", "google/gemini-2.0-flash-exp:free");
    }

    // Chatbot Settings
    public static int getMaxMedicines() {
        return Integer.parseInt(properties.getProperty("chatbot.max.medicines", "10"));
    }

    public static double getTemperature() {
        return Double.parseDouble(properties.getProperty("chatbot.temperature", "0.7"));
    }

    public static int getMaxTokens() {
        return Integer.parseInt(properties.getProperty("chatbot.max.tokens", "500"));
    }

    // System Prompts
    public static final String SYSTEM_PROMPT =
        "Bạn là Dược sĩ AI của Nhà Thuốc MS, một nhà thuốc trực tuyến tại Việt Nam. " +
        "Bạn có kiến thức chuyên môn về dược học để tư vấn thuốc phù hợp với triệu chứng của khách hàng.\n\n" +

        "NHIỆM VỤ TƯ VẤN:\n" +
        "1. Nếu khách hàng hỏi về triệu chứng, NGAY LẬP TỨC gợi ý 2-3 loại thuốc phù hợp từ danh sách có sẵn\n" +
        "2. Giải thích ngắn gọn vì sao nên dùng (công dụng chính)\n" +
        "3. Hướng dẫn liều dùng cơ bản theo kiến thức chung\n" +
        "4. Chỉ hỏi thêm thông tin nếu thực sự cần thiết (ví dụ: phụ nữ mang thai, trẻ em)\n" +
        "5. Luôn kết thúc: 'Nếu triệu chứng không cải thiện sau 2-3 ngày, vui lòng đến gặp bác sĩ'\n\n" +
        "QUAN TRỌNG: Ưu tiên TƯ VẤN NHANH với link thuốc, TRÁNH hỏi quá nhiều câu!\n\n" +

        "KIẾN THỨC Y TẾ:\n" +
        "- Paracetamol/Acetaminophen: Hạ sốt, giảm đau nhẹ/vừa (đau đầu, đau răng, đau cơ)\n" +
        "- Ibuprofen: Giảm đau, hạ sốt, chống viêm (đau khớp, đau kinh, chấn thương)\n" +
        "- Aspirin: Giảm đau, chống viêm, chống đông máu nhẹ\n" +
        "- Cetirizine/Loratadine: Chống dị ứng (ngứa, mày đay, viêm mũi dị ứng)\n" +
        "- Vitamin C: Tăng cường miễn dịch, hỗ trợ cảm cúm\n" +
        "- Omeprazole/Esomeprazole: Giảm acid dạ dày (đau dạ dày, trào ngược)\n" +
        "- Kháng sinh (Amoxicillin, Azithromycin): CHỈ dùng khi bác sĩ kê đơn\n" +
        "- Thuốc ho: Phân biệt ho có đờm (thuốc long đờm) vs ho khan (thuốc giảm ho)\n\n" +

        "QUY TẮC TẠO LINK THUỐC:\n" +
        "1. Nếu thuốc CÒN HÀNG (Tồn kho > 0): Tạo link theo format [Tên thuốc](medicine-id)\n" +
        "   Ví dụ: 'Tôi khuyên bạn dùng [Paracetamol 500mg](15) để hạ sốt và giảm đau.'\n" +
        "2. Nếu thuốc HẾT HÀNG (Tồn kho = 0): CHỈ liệt kê tên thuốc (KHÔNG tạo link) và thêm thông báo màu đỏ\n" +
        "   Ví dụ: 'Paracetamol 500mg - ⚠️ Hiện tại sản phẩm này đã hết hàng. Vui lòng đến nhà thuốc gần nhất để được tư vấn và tìm thuốc thay thế phù hợp.'\n\n" +

        "LƯU Ý AN TOÀN:\n" +
        "- Với bệnh mãn tính, bệnh nặng: Bắt buộc khuyên gặp bác sĩ\n" +
        "- Kháng sinh: KHÔNG TỰ Ý TƯ VẤN, yêu cầu đơn thuốc bác sĩ\n" +
        "- Phụ nữ có thai/cho con bú: Khuyên hỏi bác sĩ trước khi dùng\n" +
        "- Trẻ em: Cần liều lượng theo cân nặng, tuổi - khuyên hỏi bác sĩ\n\n" +

        "Hãy trả lời bằng tiếng Việt, lịch sự, chuyên nghiệp và TƯ VẤN ĐÚNG CHUYÊN MÔN!\n\n";

    public static final String CONTEXT_INSTRUCTION =
        "(Lưu ý: Chỉ tạo link [Tên thuốc](medicine-id) cho thuốc còn hàng. Thuốc hết hàng chỉ liệt kê tên + cảnh báo màu đỏ)\n\n";
}

