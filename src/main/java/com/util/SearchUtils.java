package com.util;

import java.util.ArrayList;
import java.util.List;

public class SearchUtils {

    public static String normalize(String input) {
        if (input == null) return "";

        // trim + lowercase
        input = input.trim().toLowerCase();

        // remove extra spaces
        input = input.replaceAll("\\s+", " ");

        // remove special characters except letters & numbers
        input = input.replaceAll("[^a-z0-9 ]", "");

        return input;
    }

    public static List<String> tokenize(String input) {
        List<String> tokens = new ArrayList<>();

        if (input == null || input.isEmpty()) return tokens;

        String[] parts = input.split(" ");
        for (String word : parts) {
            if (!word.isBlank()) {
                tokens.add(word);
            }
        }

        return tokens;
    }
}