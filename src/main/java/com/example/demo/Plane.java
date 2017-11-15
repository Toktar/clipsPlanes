package com.example.demo;

/**
 * Created by toktar.
 */
//@Getter
//@Setter
public class Plane {
    private String start;
    private String end;
    private Double cost;
    private Double weight;
    private Long factId;

    public Plane(String start, String end, Double cost, Double weight) {
        this.start = start;
        this.end = end;
        this.cost = cost;
        this.weight = weight;
    }

    public Plane(String start, String end, Double cost, Double weight, Long factId) {
        this.factId = factId;
        this.weight = weight;
        this.cost = cost;
        this.end = end;
        this.start = start;
    }

    public Long getFactId() {
        return factId;
    }

    public void setFactId(Long factId) {
        this.factId = factId;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }
}
