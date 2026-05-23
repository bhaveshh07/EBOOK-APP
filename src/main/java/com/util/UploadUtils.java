package com.util;

import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;

import jakarta.servlet.http.Part;

public class UploadUtils {

    // Max 5MB
    public static final long MAX_SIZE = 5 * 1024 * 1024;

    // Allowed mime types
    private static final String[] ALLOWED_TYPES = {
            "image/jpeg",
            "image/png",
            "image/jpg",
            "image/webp"
    };

    public static String validateAndSaveImage(Part part, String uploadPath)
            throws Exception {

        if (part == null || part.getSize() == 0) {
            return null;
        }

        // 1. Size check
        if (part.getSize() > MAX_SIZE) {
            throw new Exception("File size exceeds 5MB");
        }

        // 2. Mime type check
        String mime = part.getContentType();
        boolean allowed = false;

        for (String type : ALLOWED_TYPES) {
            if (type.equalsIgnoreCase(mime)) {
                allowed = true;
                break;
            }
        }

        if (!allowed) {
            throw new Exception("Only JPG, PNG, WEBP images are allowed\r\n"
                                );
        }

        // 3. Get extension
        String original = Paths.get(part.getSubmittedFileName())
                .getFileName().toString();

        String ext = original.substring(original.lastIndexOf("."));

        // 4. Generate safe filename
        String fileName = UUID.randomUUID().toString() + ext;

        // 5. Create folder
        File dir = new File(uploadPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 6. Save file
        part.write(uploadPath + File.separator + fileName);

        return fileName;
    }
}
