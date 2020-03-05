using TextAnalysis

garbage_words = ["’", "”", "“", "-"]

pArts = []
nArts = []

function assembleDocs()
    for(root, dirs, files) in walkdir("./articles/positive")
        for file in files
            path = joinpath(root, file)
            push!(pArts, StringDocument(text(FileDocument(path))))
        end
    end
    for(root, dirs, files) in walkdir("./articles/negative")
        for file in files
            path = joinpath(root, file)
            push!(nArts, StringDocument(text(FileDocument(path))))
        end
    end
end

function prepCorp(corp)
    prepare!(corp, strip_case | stem_words | strip_punctuation | strip_articles | strip_stopwords | strip_numbers)
    #remove_words!(corp, garbage_words)
    update_lexicon!(corp)
end

function removeOverlap(crps1, crps2)
    pWords = Set(keys(lexicon(crps1)))
    nWords = Set(keys(lexicon(crps2)))
    removeWords = collect(intersect(pWords, nWords))
    remove_words!(crps1, removeWords)
    remove_words!(crps2, removeWords)
end

function execute()
    assembleDocs()
    pCrps = Corpus(pArts)
    nCrps = Corpus(nArts)
    prepCorp(pCrps)
    prepCorp(nCrps)
    removeOverlap(pCrps, nCrps)
    update_lexicon!(pCrps)
    update_lexicon!(nCrps)
    println("Positive Words:")
    for t in lexicon(pCrps)
        println(t)
    end
    println("\n\nNegativeWords:")
    for t in lexicon(nCrps)
        println(t)
    end
end

execute()