require 'helper'

class TestCorpus < Test::Unit::TestCase
  def test_adding_documents_increments_document_count
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow")
    doc2 = Document.new("horse horse horse")

    corpus << doc1
    corpus << doc2

    assert_equal corpus.document_count, 2
  end

  def test_adding_documents_adds_terms
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow bird")
    doc2 = Document.new("horse horse horse bird")

    corpus << doc1
    corpus << doc2

    assert_equal 3, corpus.terms.size

    # cow appears in one document
    assert_equal 1, corpus.terms['cow']

    # horse appears in one document
    assert_equal 1, corpus.terms['horse']

    # bird appears in both documents
    assert_equal 2, corpus.terms['bird']
  end

  def test_inverse_document_frequency
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow")
    doc2 = Document.new("horse horse horse")

    corpus << doc1
    corpus << doc2

    # There's 2 documents and the term appears in 1, so idf = log(2/ (1+1)) = 0
    assert_in_delta corpus.inverse_document_frequency("cow"), 0.0, 0.1

    # There's 2 documents and the term appears in 0, so idf = log(2/1) = 0.69314718056
    assert_in_delta corpus.inverse_document_frequency("bird"), 0.693, 0.001
  end

  # using worked example from log book, this should return a similarity of 1
  def test_similarity_matrix
    corpus = Corpus.new
    doc1 = Document.new("cow horse sheep")
    doc2 = Document.new("horse bird dog")

    corpus << doc1
    corpus << doc2

    matrix = corpus.similarity_matrix
    assert_in_delta 1, matrix[0,0], 0.1
    assert_in_delta 1, matrix[0,1], 0.1
  end
end
