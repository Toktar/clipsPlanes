package com.example.demo;

import net.sf.clipsrules.jni.Environment;
import net.sf.clipsrules.jni.FactAddressValue;
import net.sf.clipsrules.jni.MultifieldValue;
import net.sf.clipsrules.jni.PrimitiveValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by toktar.
 */

@RestController
public class PlaneController {
    private final static String CLIPS_FILE = "C:\\Users\\toktar\\Desktop\\clipsBotles\\zebra.clp";
    private final static String CLIPS_LIB = "C:\\Users\\toktar\\Desktop\\clipsBotles\\CLIPSJNI.dll";
    private int queryId = 1;
    private Environment clips;

    @Autowired
    ViewService viewService;

    @PostConstruct
    private void initPostConstruct() {
        clips = getClips();
        clips.reset();
    }

    @RequestMapping("/res")
    String getResult(@RequestParam(name = "start", required = false) String start,
                     @RequestParam(name = "end", required = false) String end,
                     @RequestParam(name = "weight", required = false) Double weight,
                     @RequestParam(name = "cost", required = false) Double cost,
                     @RequestParam(name = "operation", required = false) String operation,
                     @RequestParam(name = "id", required = false) Long factIdForChange
    ) {
       /* start = "A";
        end = "B";
        weight = 2.0;*/



        clips.run();
        List<Plane> resultPlanes = new ArrayList<Plane>();
        if(operation!=null) {
            switch (Operation.valueOf(operation)) {
                case DELETE: deleteFact(factIdForChange);
                    break;
                case NEW: newPlane(start,end,weight,cost);
            }

        } else if(start!=null && end!=null && weight!=null) {
            resultPlanes = getCorrectPlanes(start, end, weight);
        }
        List<Plane> allPlanes = getAllPlanes();
        return viewService.generateAnswerForUser(resultPlanes, allPlanes);
    }

    private void newPlane(String start, String end, Double weight, Double cost) {
        clips.eval("(assert (plane (weight "+weight+")(start \""+start+"\")(end \""+end+"\")(cost " + cost +")))\n");
    }

    private void deleteFact(Long factIdForChange) {
        clips.eval("(retract "+factIdForChange+")");
    }


    private List<Plane> getAllPlanes() {
        List<Plane> result = new ArrayList<Plane>();
        MultifieldValue answersFacts = (MultifieldValue) clips.eval("(find-all-facts ((?f plane)) TRUE)");
        if (answersFacts.multifieldValue().size() == 0) return result;
        List<FactAddressValue> planeList = answersFacts.multifieldValue();
        for (FactAddressValue fact : planeList) {
            Long factId = fact.getFactIndex();
            result.add(new Plane(
                    getSlot(factId, "start"),
                    getSlot(factId, "end"),
                    Double.parseDouble(getSlot(factId, "weight")),
                    Double.parseDouble(getSlot(factId, "cost")),
                    factId
            ));
        }
        return result;
    }

/*
    private String getAnswerFact(String id, Environment clips) {
        StringBuffer out = new StringBuffer();
        out.append("Маршрут: ").append(clips.eval("fact-slot-value " + id + " start") + " - " + clips.eval("fact-slot-value " + id + " end"))
                .append("\nДопустимый вес: ").append(clips.eval("fact-slot-value " + id + " weight"))
                .append("\nЦена перевозки: ").append(clips.eval("fact-slot-value " + id + " cost"));
        return out.toString();

    }*/

    private List<Plane> getCorrectPlanes(String start, String end, double weight) {
        List<Plane> result = new ArrayList<Plane>();
        queryId++;
        int id = queryId;
        clips.eval("(can-fly \"" + start + "\" \"" + end + "\" " + (int)weight + " " + id + ")");
        clips.run();
        clips.eval("(facts)");
        MultifieldValue answersFacts = (MultifieldValue) clips.eval("(find-all-facts ((?f answer)) (eq ?f:id  " + id + "))");
        if (answersFacts.multifieldValue().size() == 0) return result;
        List<FactAddressValue> planeList = answersFacts.multifieldValue();
        for (FactAddressValue fact : planeList) {
            Long factId = fact.getFactIndex();
            result.add(new Plane(
                    getSlot(factId, "start"),
                    getSlot(factId, "end"),
                    Double.parseDouble(getSlot(factId, "weight")),
                    Double.parseDouble(getSlot(factId, "cost"))
            ));

            clips.eval("(retract "+factId+")");
        }


        return result;
    }

    private String getSlot(Long factId, String field) {
        PrimitiveValue res = clips.eval("(fact-slot-value " + factId + " " + field +")" );
        return res.getValue().toString();
    }

    public Environment getClips() {
        Environment clips = new Environment();
        clips.load(CLIPS_FILE);
        System.load(CLIPS_LIB);
        return clips;
    }
}
