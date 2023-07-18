using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    [SerializeField] GameObject player;
    Vector3 Offset;

    private void Start()
    {
        Offset = new Vector3(0,10,-7);
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = player.transform.position + Offset;
    }
}
