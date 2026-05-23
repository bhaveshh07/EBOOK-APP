package com.DAO;

import java.util.List;

import com.entity.Genre;

public interface GenreDAO {

    boolean addGenre(Genre g);

    List<Genre> getAllGenres();

    Genre getGenreById(int id);

    boolean updateGenre(Genre g);

    boolean toggleGenreStatus(int id);

    List<Integer> getGenreIdsByBookId(int bookId);

    void addBookGenreMapping(int bookId, int genreId);

    void deleteBookGenres(int bookId);

}
